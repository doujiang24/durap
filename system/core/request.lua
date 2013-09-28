-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local corehelper = require "helper.core"
local cjson = require "cjson"
local upload = require "resty.upload"

local ngx = ngx
local ngx_var = ngx.var
local ngx_req = ngx.req
local ngx_header = ngx.header

local setmetatable = setmetatable

local log_error = corehelper.log_error
local read_body = ngx.req.read_body
local get_headers = ngx.req.get_headers
local get_uri_args = ngx.req.get_uri_args
local get_post_args = ngx.req.get_post_args
local unescape_uri = ngx.unescape_uri
local pairs = pairs
local error = error
local type = type
local io_open = io.open
local insert = table.insert
local concat = table.concat
local sub = string.sub
local match = string.match
local find = string.find
local cookie_time = ngx.cookie_time
local time = ngx.time
local pairs = pairs
local random = math.random
local get_instance = get_instance

local set_encrypt_session = ndk.set_var.set_encrypt_session
local set_decrypt_session = ndk.set_var.set_decrypt_session
local set_encode_base64 = ndk.set_var.set_encode_base64
local set_decode_base64 = ndk.set_var.set_decode_base64


module(...)

_VERSION = '0.01'
chunk_size = 8096

local session_key = '_LUASES_'

local mt = { __index = _M }

local function _get_uri_args(self)
    self.get_vars = get_uri_args()

    return self.get_vars
end

local function _get_headers(self)
    if not self.headers then
        self.headers = get_headers()
    end
    return self.headers
end

function ip_address()
    return ngx_var.remote_addr
end

local function _tmp_name(self)
    return self.apppath .. "tmp/" .. time() .. ip_address() .. random(10000, 99999)
end

local function _get_post_form(self)
    local tmp_files, ret = self.tmp_files, {}
    local form, err = upload:new(chunk_size)
    if not form then
        log_error("failed to new upload: ", err)
    end

    form:set_timeout(3000) -- 3 sec

    local k, v, fn, ft, tn
    while true do
        local typ, res, err = form:read()
        if not typ then
            log_error("failed to read upload form: ", err)
            return ret
        end

        if typ == "header" then
            if res[1] == "Content-Disposition" then
                k = match(res[2], "name=\"(.-)\"")
                fn= match(res[2], "filename=\"(.-)\"")
            elseif res[1] == "Content-Type" then
                ft = res[2]
            end

            if fn and ft then
                tn = _tmp_name(self)
                v, err = io_open(tn, 'w')
                if not v then
                    log_error('failed open tmpfile', err)
                end
            end
        end

        if typ == "body" then
            if type(v) == "userdata" then
                v:write(res)
            else
                v = v and v .. res or res
            end
        end

        if typ == "part_end" then
            if type(v) == "userdata" then
                v:close()
                v = { filename = fn, tmpname = tn, filetype = ft }
                insert(tmp_files, tn)
            end

            local kv = ret[k]
            if type(kv) == "nil" then
                ret[k] = v
            elseif type(kv) == "table" and #kv >= 1 then
                insert(ret[k], v)
            else
                ret[k] = { ret[k], v }
            end

            k, v, fn, ft, tn = nil, nil, nil, nil, nil
        end

        if typ == "eof" then
            break
        end
    end

    return ret
end

local function _get_post_args(self)
    self.post_vars = {}
    if self.method == "POST" then
        local headers = _get_headers(self)
        if headers['Content-Type'] and sub(headers['Content-Type'], 1, 19) == "multipart/form-data" then
            self.post_vars = _get_post_form(self)
        else
            read_body()
            self.post_vars = get_post_args()
        end
    end
    return self.post_vars
end

function new(self, apppath)
    local res = {
        method           = ngx_var.request_method,
        schema           = ngx_var.schema,
        host             = ngx_var.host,
        hostname         = ngx_var.hostname,
        request_uri      = ngx_var.request_uri,
        uri              = ngx_var.router_uri,
        request_filename = ngx_var.request_filename,
        query_string     = ngx_var.query_string,
        user_agent       = ngx_var.http_user_agent,
        remote_addr      = ngx_var.remote_addr,
        remote_port      = ngx_var.remote_port,
        remote_user      = ngx_var.remote_user,
        remote_passwd    = ngx_var.remote_passwd,
        content_type     = ngx_var.content_type,
        content_length   = ngx_var.content_length,
        header           = ngx_header,
        apppath = apppath,
        tmp_files = {},
        cookie_set = {},
        session_vars = nil,
        get_vars = nil,
        post_vars = nil,
        input_vars = nil,
        headers = nil
    }
    return setmetatable(res, mt)
end

function get(self, key)
    local get_vars = self.get_vars or _get_uri_args(self)
    if key then
        return get_vars[key]
    end
    return get_vars
end

function post(self, key)
    local post_vars = self.post_vars or _get_post_args(self)

    if key then
        return post_vars[key]
    end
    return post_vars
end

function input(self, key)
    if not self.input_vars then
        local vars = get(self)
        local post = post(self)
        for k, v in pairs(post) do
            vars[k] = v
        end
        self.input_vars = vars
    end
    return self.input_vars
end

local function _set_cookie(self)
    local set, t = self.cookie_set, {}
    for k, v in pairs(set) do
        insert(t, v)
    end
    self.header['Set-Cookie'] = t
    if ngx.headers_sent then
        log_error('failed to set cookie, header has seeded')
        return false
    end
    return true
end

function cookie(self, key)
    if key then
        return ngx_var["cookie_" .. key]
    end
end

function set_cookie(self, key, value, expire, path, domain, secure, httponly)
    local cookie = {}
    insert(cookie, key .. "=" .. value)
    if expire then
        insert(cookie, "expires=" .. cookie_time(expire))
    end
    if path then
        insert(cookie, "path=" .. path)
    end
    if domain then
        insert(cookie, "domain=" .. domain)
    end
    if secure then
        insert(cookie, "secure")
    end
    if httponly then
        insert(cookie, "httponly")
    end
    local cookie_str = concat(cookie, "; ")
    self.cookie_set[key] = cookie_str

    return _set_cookie(self)
end

local function _session(self)
    if not self.session_vars then
        local ses_str, ses = cookie(self, session_key), {}
        if ses_str then
            ses = cjson.decode(set_decrypt_session(set_decode_base64(ses_str)))
            ses = cjson.decode(set_decrypt_session(set_decode_base64(ses_str)))
            if not ses or type(ses) ~= "table" then
                log_error('failed to decode session, session_str:', ses_str)
                ses = {}
            end
        end
        self.session_vars = ses
        return ses
    end
    return self.session_vars
end

function session(self, key)
    local ses = _session(self)
    if key then
        return ses[key]
    end
    return ses
end

function set_session(self, key, value)
    local ses = _session(self)
    ses[key] = value
    local ses_str = set_encode_base64(set_encrypt_session(cjson.encode(ses)))
    set_cookie(self, session_key, ses_str, nil, '/', self.host)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

