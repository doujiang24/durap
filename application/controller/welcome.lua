-- Copyright (C) 2013 MaMa

local dp = get_instance()

local loader = dp.loader
local ngx = ngx
local type = type
local setmetatable = setmetatable

function hello(name)
    ngx.say('say hello, ', name)
end

function database()
    local MWelcome = loader:model('welcome')
    local welcome = MWelcome:new()
    welcome:add('dou')

    local total = welcome:count()
    ngx.say('total num : ', total)
end
