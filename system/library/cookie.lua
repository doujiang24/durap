-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local corehelper = require "helper.core"

local setmetatable = setmetatable
local error = error
local insert = table.insert
local concat = table.concat
local log_error = corehelper.log_error
local get_instance = get_instance
local ngx = ngx
local ngx_var = ngx.var
local time = ngx.time
local ngx_var = ngx.var
local ngx_header = ngx.header

local set_encode_base64 = ndk.set_var.set_encode_base64
local set_decode_base64 = ndk.set_var.set_decode_base64


module(...)

_VERSION = '0.01'


function get(self, key)
    if key then
        return ngx_var["cookie_" .. key]
    end
end

function set(self, key, value, expire, path, domain, secure, httponly)
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
    local str = concat(cookie, "; ")

    ngx_header['Set-Cookie'] = str
    if ngx.headers_sent then
        log_error('failed to set cookie, header has seeded')
        return false
    end
    return true
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

