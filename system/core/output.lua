-- Copyright (C) 2013 MaMa

local cjson = require "cjson"

local get_instance = get_instance
local say = ngx.say
local exit = ngx.exit
local json_encode = cjson.encode
local ngx = ngx


local _M = { _VERSION = '0.01' }

function _M.set_header(key, val)
    if not ngx.headers_sent then
        ngx.header[key] = val
        return true
    end

    get_instance().debug:log_error('headers has been sent, when set_header, key:', key, 'val:', val)
end

local function encode(status, data, errmsg, errno, extra, ...)
    local ret = {
        status = status or 0,
        data = data or {},
        errmsg = {
            errno = errno or 0,
            msg = errmsg or '',
        }
    }

    if extra then
        local t = { extra, ... }
        for i = 1, #t, 2 do
            ret[t[i]] = t[i + 1]
        end
    end

    return json_encode(ret)
end

function _M.json(status, ...)
    say(encode(status, ...))
    return status == 1 and true or nil
end

function _M.json_error(errmsg, errno, ...)
    _M.json(0, nil, errmsg, errno, ...)
    get_instance().debug:log_debug(errmsg)
end

function _M.json_data(data)
    return _M.json(1, data, '', 0)
end

function _M.json_callback(callback, status, ...)
    say(callback .. "(" .. encode(status, ...) .. ")")
    return status == 1 and true or nil
end

return _M
