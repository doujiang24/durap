-- Copyright (C) 2013 MaMa

local ngx = ngx -- only for ngx.ctx
local ngx_var = ngx.var

local request = require "core.request"
local loader = require "core.loader"
local debug = require "core.debug"

local _G = _G
local getmetatable = getmetatable
local setmetatable = setmetatable


module(...)

local mt = { __index = _M }

function get_instance()
    return ngx.ctx.dp
end

local function _allover_init()
    if not _G.get_instance then
        _G.get_instance = get_instance
    end

    if not _G.cache_module then
        _G.cache_module = {}
    end
end

function init(self, level)
    _allover_init()

    local APPNAME = ngx_var.APPNAME
    local APPPATH = ngx_var.ROOT .. ngx_var.APPNAME .. "/"
    local req = request:new()
    local dbg = debug:init(level, req, APPPATH)

    ngx.ctx.dp = setmetatable({
        APPNAME = APPNAME,
        APPPATH = APPPATH,
        request = req,
        loader = loader:new(APPNAME, APPPATH),
        debug = dbg
    }, mt)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

