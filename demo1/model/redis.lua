-- Copyright (C) Dejiang Zhu (doujiang24)

local redis = require "system.database.redis"

local setmetatable  = setmetatable
local get_instance  = get_instance
local time          = ngx.localtime


-- constants
local config    = get_instance().loader:config('redis')
local key       = "welcome"

local _M = {}
local mt = { __index = _M }

function _M.new(self)
    local red = redis:connect(config)

    if red then
        return setmetatable({ red = red }, mt)
    end
end

function _M.add(self, name)
    local red = self.red
    return red:set(key, name)
end

function _M.get(self)
    local red = self.red
    return red:get(key)
end

function _M.close(self)
    local red = self.red
    return red:keepalive()
end


return _M

