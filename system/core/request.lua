-- Copyright (C) 2013 MaMa

local ngx_var = ngx.var
local ngx_req = ngx.req

local setmetatable = setmetatable

local read_body = ngx.req.read_body
local get_uri_args = ngx.req.get_uri_args
local get_post_args = ngx.req.get_post_args
local unescape_uri = ngx.unescape_uri
local pairs = pairs
local error = error


module(...)

_VERSION = '0.01'


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

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

