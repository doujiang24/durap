-- Copyright (C) 2013 MaMa

local durap = require "core.durap"
ngx.ctx.dp = durap:init()


local router = require "core.router"
local rout = router:new()




--[[
ngx.say(type(get_instance))
ngx.say(type(get_instance()))
ngx.say(type(ngx.ctx.dp))
--]]
