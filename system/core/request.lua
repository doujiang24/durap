-- Copyright (C) 2013 doujiang24, MaMa Inc.

local corehelper = require "helper.core"
local filehelper = require "helper.file"
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
local pairs = pairs
local type = type
local io_open = io.open
local insert = table.insert
local concat = table.concat
local sub = string.sub
local match = string.match
local find = string.find
local time = ngx.time
local random = math.random
local get_instance = get_instance
local file_exists = filehelper.exists
local file_remove = filehelper.remove


local _M = { _VERSION = '0.01' }


local chunk_size = 8096

local mt = { __index = _M }

local function _get_uri_args(self)
    self.get_vars = get_uri_args()

    return self.get_vars
end

function _M.ip_address()
    return ngx_var.remote_addr
end

local function _tmp_name(self)
    local apppath = get_instance().APPPATH
    return apppath .. "tmp/" .. time() .. _M.ip_address() .. random(10000, 99999)
end

local function _clear(self)
    local tmp_files = self.tmp_files
    for _, file in ipairs(tmp_files) do
        if file_exists(file) then
            file_remove(file)
        end
    end
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
        local typ = _M.headers(self, 'Content-Type')
        if typ and sub(typ, 1, 19) == "multipart/form-data" then
            self.post_vars = _get_post_form(self)
        else
            read_body()
            self.post_vars = get_post_args()
        end
    end
    return self.post_vars
end

function _M.new(self)
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
        tmp_files = {},
        get_vars = nil,
        post_vars = nil,
        input_vars = nil,
        header_vars = nil
    }
    return setmetatable(res, mt)
end

function _M.headers(self, key)
    if not self.header_vars then
        self.header_vars = get_headers()
    end
    if key then
        return self.header_vars[key]
    else
        return self.header_vars
    end
end

function _M.get(self, key)
    local get_vars = self.get_vars or _get_uri_args(self)
    if key then
        return get_vars[key]
    end
    return get_vars
end

function _M.post(self, key)
    local post_vars = self.post_vars or _get_post_args(self)

    if key then
        return post_vars[key]
    end
    return post_vars
end

function _M.input(self, key)
    if not self.input_vars then
        local vars = _M.get(self)
        local post = _M.post(self)
        for k, v in pairs(post) do
            vars[k] = v
        end
        self.input_vars = vars
    end
    if key then
        return self.input_vars[key]
    else
        return self.input_vars
    end
end

return _M
