-- Copyright (C) 2013 MaMa

local debug = require "core.debug"
local durap = require "core.durap"

durap:init(debug.DEBUG)

debug = get_instance().debug

local router = require "core.router"
local rt = router:new()

local ctr, func, args = rt:route()

if not ctr then
    ngx.exit(404)
end

ctr[func](unpack(args));
