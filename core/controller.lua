-- Copyright

module("core.controller", package.seeall)

local uri = require("core.uri")

local mod_name = uri.get_module()

ngx.say(mod_name)
local mod = require(mod_name)

ngx.say(mod)
