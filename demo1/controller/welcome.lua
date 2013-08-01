-- Copyright (C) 2013 MaMa

local dp = get_instance()
local cjson = require "cjson"

local loader = dp.loader
local ngx = ngx
local type = type
local setmetatable = setmetatable
local tonumber = tonumber

local require = require

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
