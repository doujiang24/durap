-- Copyright (C) 2013 MaMa

local durap = require "core.durap"


local dp = durap:init()

local router = require "core.router"
local rt = router:new()
dp.router = rt

local ctr, func, args = rt:route()

if not ctr then
    ngx.exit(404)
end

--assert(pcall(ctr[func], unpack(args)))
ctr[func](unpack(args))
