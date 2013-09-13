-- Copyright (C) 2013 MaMa

local cjson = require "cjson"

local ngx = ngx
local ngx_var = ngx.var
local ngx_req = ngx.req
local ngx_header = ngx.header

local setmetatable = setmetatable

local read_body = ngx.req.read_body
local get_uri_args = ngx.req.get_uri_args
local get_post_args = ngx.req.get_post_args
local unescape_uri = ngx.unescape_uri
local pairs = pairs
local error = error
local type = type
local insert = table.insert
local concat = table.concat
local cookie_time = ngx.cookie_time
local pairs = pairs
local get_instance = get_instance

local set_encrypt_session = ndk.set_var.set_encrypt_session
local set_decrypt_session = ndk.set_var.set_decrypt_session
local set_encode_base64 = ndk.set_var.set_encode_base64
local set_decode_base64 = ndk.set_var.set_decode_base64


module(...)

_VERSION = '0.01'

local session_key = '_LUASES_'

local mt = { __index = _M }

local function _get_uri_args(self)
    if not self.get_vars then
        self.get_vars = get_uri_args()
    end

    return self.get_vars
end

local function _get_post_args(self)
    if not self.post_vars then
        read_body()
        self.post_vars = get_post_args()
    end
    return self.post_vars
end

function new(self, config)
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
        cookie_set = {},
        session_vars = nil,
        get_vars = nil,
        post_vars = nil,
        input_vars = nil,
        headers = nil
    }
    return setmetatable(res, mt)
end

function _get(self, key)
    local get_vars = _get_uri_args(self)
    if key then
        return get_vars[key]
    end
    return get_vars
end

function _post(self, key)
    local post_vars = _get_post_args(self)

    if key then
        return post_vars[key]
    end
    return post_vars
end

function input(self, key)
    if not self.input_vars then
        local vars = _get(self)
        local post = _post(self)
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
        local debug = get_instance().debug
        debug:log(debug.ERR, 'failed to set cookie, header has seeded')
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
                local debug = get_instance().debug
                debug:log(debug.ERR, 'failed to decode session, session_str:', ses_str)
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

