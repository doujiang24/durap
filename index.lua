-- Copyright (C) 2013 MaMa

local durap = require "core.durap"
ngx.ctx.dp = durap:init()


local router = require "core.router"
local rt = router:new()

local ctr, func, args = rt:set_router()


ctr[func](unpack(args));

local str = "women'hoho`'`"
ngx.say(ndk.set_var.set_quote_sql_str(str))
ngx.say(ngx.quote_sql_str(str))


--[[
local mysql = require "database.mysql"
local config = ngx.ctx.dp.loader:config('mysql')
local my = mysql:connect(config)
--mysql:count('welcome')
--]]


--[[
local request = require "core.request"
local req = request:new()
ngx.say(req.uri)
--]]


--[[
ngx.say(type(get_instance))
ngx.say(type(get_instance()))
ngx.say(type(ngx.ctx.dp))
--]]
