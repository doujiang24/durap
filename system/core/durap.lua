-- Copyright (C) 2013 MaMa

local ngx_var = ngx.var
local ngx_ctx = ngx.ctx

local request = require "core.request"

local r_G = _G
local getmetatable = getmetatable
local setmetatable = setmetatable
local rawget = rawget


local say = ngx.say
local type = type

module(...)

local mt = { __index = _M }

function get_instance()
    return ngx_ctx.dp
end

local function _allover_init()
    local rmt = getmetatable(r_G)
    if rmt then
        r_G = rawget(rmt, "__index")
    end

    if not r_G.get_instance then
        r_G.get_instance = get_instance
    end
end

function init(self)
    _allover_init()

    return setmetatable({
        APPNAME = ngx_var.APPNAME,
        APPPATH = ngx.var.ROOT .. ngx.var.APPNAME .. "/",
        request = request:new()
    }, mt)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

