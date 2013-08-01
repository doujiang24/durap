-- Copyright (C) 2013 MaMa

local redis = require "database.redis"

local setmetatable = setmetatable
local error = error
local time = ngx.localtime
local get_instance = get_instance

-- debug
local ngx = ngx
local type = type

_VERSION = '0.01'

-- constants
local key = "welcome"

local _M = getfenv()
local mt = { __index = _M }

function new(self)
    local dp = get_instance()
    local config = dp.loader:config('redis')
    return setmetatable({ redis = redis:connect(config) }, mt)
end

function add(self, name)
    local redis = self.redis
    return redis:set(key, name)
end

function get(self)
    local redis = self.redis
    return redis:get(key)
end

function keepalive(self)
    local redis = self.redis
    return redis:keepalive()
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

