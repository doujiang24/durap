-- Copyright (C) Dejiang Zhu (doujiang24)

local redis = require "system.database.redis"

local setmetatable = setmetatable
local error = error
local time = ngx.localtime
local get_instance = get_instance


-- constants
local key = "welcome"

local _M = {}
local mt = { __index = _M }

function _M.new(self)
    local dp = get_instance()
    local config = dp.loader:config('redis')
    return setmetatable({ redis = redis:connect(config) }, mt)
end

function _M.add(self, name)
    local redis = self.redis
    return redis:set(key, name)
end

function _M.get(self)
    local redis = self.redis
    return redis:get(key)
end

function _M.keepalive(self)
    local redis = self.redis
    return redis:keepalive()
end


return _M
