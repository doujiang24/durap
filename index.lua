-- Copyright (C) 2013 MaMa

local durap = require "core.durap"


local dp = durap:init()

local router = require "core.router"
local rt = router:new()
dp.router = rt

return rt:run()
