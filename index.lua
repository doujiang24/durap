-- Copyright (C) 2013 MaMa

local r_G = _G
local mt = getmetatable(r_G)
if mt then
    r_G = rawget(mt, "__index")
end

if not r_G.get_instance then
    r_G.get_instance = function ()
        return ngx.ctx.dp
    end
end

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
