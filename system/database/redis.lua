-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local redis = require "resty.redis"
local corehelper = require "helper.core"

local log_error = corehelper.log_error
local setmetatable = setmetatable
local error = error
local unpack = unpack
local get_instance = get_instance


module(...)

_VERSION = '0.01'


local mt = { __index = _M }

function connect(self, config)
    local red = setmetatable({ conn = redis:new(), config = config }, mt);

    local conn = red.conn
    local host = config.host
    local port = config.port
    local timeout = config.timeout

    conn:set_timeout(timeout)
    local ok, err = conn:connect(host, port)

    if not ok then
        log_error("failed to connect redis: ", err)
        return
    end

    return red
end

function close(self)
    local conn = self.conn
    local ok, err = conn:close()
    if not ok then
        log_error("failed to close redis: ", err)
    end
end

function keepalive(self)
    local conn, config = self.conn, self.config
    if not config.idle_timeout or not config.max_keepalive then
        log_error("not set idle_timeout and max_keepalive in config; turn to close")
        return close(self)
    end
    local ok, err = conn:set_keepalive(config.idle_timeout, config.max_keepalive)
    if not ok then
        log_error("failed to set redis keepalive: ", err)
    end
end

function commit_pipeline(self)
    local conn, ret = self.conn, {}
    local results, err = conn:commit_pipeline()

    if not results then
        log_error("failed to commit the pipelined requests: ", err)
        return ret
    end

    for i, res in ipairs(results) do
        if type(res) == "table" then
            if not res[1] then
                log_error("failed to run command: ", i, "; err:", res[2])
                insert(ret, false)
            else
                insert(ret, res[1])
            end
        else
            insert(ret, false)
            log_error("cannot hander the scalar value, command :", i, res)
        end
    end
    return ret
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end,
    -- to call resty.redis
    __index = function (table, key)
        return function (self, ...)
            local conn = self.conn
            local res, err = conn[key](conn, ...)
            if not res and err then
                local args = { ... }
                log_error("failed to query redis, error:", err, "operater:", key, unpack(args))
                return false
            end
            return res
        end
    end
}

setmetatable(_M, class_mt)

