-- Copyright (C) 2013 MaMa

local dp = get_instance()
local cjson = require "cjson"

local loader = dp.loader
local ngx = ngx
local type = type
local setmetatable = setmetatable

local require = require

function hello(name)
    ngx.say('say hello, ', name)
end

function database()
    local MWelcome = loader:model('welcome')
    local welcome = MWelcome:new()
    welcome:add('dou')

    local total = welcome:count()
    ngx.say('total num : ', total)

    local res = welcome:list()
    ngx.say(cjson.encode(res))
end
