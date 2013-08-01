-- Copyright (C) 2013 MaMa

local dp = get_instance()
local cjson = require "cjson"

local loader = dp.loader
local ngx = ngx
local type = type
local setmetatable = setmetatable
local tonumber = tonumber
local error = error

local _M = getfenv()

function hello(name)
    ngx.say('say hello, ', name, ".")
end

function database()
    local MWelcome = loader:model('welcome')
    local welcome = MWelcome:new()

    local res = welcome:create()
    if res then
        ngx.say('table welcome created.')
    end

    local res = welcome:add('dou')
    if res then
        ngx.say('new one added.')
    end

    local total = welcome:count()
    local res = welcome:list()
    welcome:keepalive()

    if tonumber(total) == #res then
        ngx.say('count num match list count.')
    end
end

function redis(name)
    local Mredis = loader:model('redis')
    local redis = Mredis:new()

    local res = redis:add(name)
    if res then
        ngx.say('add success')
    end

    local res = redis:get()
    if res then
        ngx.say('get success')
    end

    redis:keepalive()

    if res == name then
        ngx.say('get match the add')
    end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

