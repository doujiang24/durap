-- Copyright (C) 2013 MaMa

local redis = require "resty.redis"

local setmetatable = setmetatable
local error = error
local unpack = unpack
local get_instance = get_instance


module(...)

_VERSION = '0.01'


local mt = { __index = _M }

function connect(self, config)
    local debug = get_instance().debug
    local red = setmetatable({ conn = redis:new(), config = config, debug = debug }, mt);

    local conn = red.conn
    local host = config.host
    local port = config.port
    local timeout = config.timeout

    conn:set_timeout(timeout)
    local ok, err = conn:connect(host, port)

    if not ok then
        debug:log(debug.ERR, "failed to connect redis: ", err)
        return
    end

    return red
end


function keepalive(self)
    local conn, debug = self.conn, self.debug
    local max_keepalive = self.config.max_keepalive
    local ok, err = conn:set_keepalive(0, max_keepalive)
        if not ok then
            debug:log(debug.ERR, "failed to set redis keepalive: ", err)
        return
    end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end,
    -- to call resty.redis
    __index = function (table, key)
        return function (self, ...)
            local conn, debug = self.conn, self.debug
            local res, err = conn[key](conn, ...)
            if not res then
                local args = { ... }
                debug:log(debug.ERR, "failed to query redis, error:", err, "operater:", unpack(args))
                return nil
            end
            return res
        end
    end
}

setmetatable(_M, class_mt)

