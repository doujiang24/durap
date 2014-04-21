-- Copyright (C) Dejiang Zhu (doujiang24)

local cjson = require "cjson"

local ngx = ngx
local get_instance = get_instance
local type = type
local setmetatable = setmetatable
local tonumber = tonumber
local error = error

local _M = {}

function _M.hello(name)
    ngx.say('say hello, ', name, ".")
end

function _M.database()
    local loader = get_instance().loader
    local welcome = loader:model('welcome')

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

function _M.redis(name)
    local loader = get_instance().loader
    local redis = loader:model('redis')

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

return _M
