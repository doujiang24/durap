-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local ngx = ngx -- only for ngx.ctx
local ngx_var = ngx.var

local request = require "core.request"
local loader = require "core.loader"
local debug = require "core.debug"

local getmetatable = getmetatable
local setmetatable = setmetatable
local rawget = rawget


module(...)

local mt = { __index = _M }

function init(self, level)
    local APPNAME = ngx_var.APPNAME
    local APPPATH = ngx_var.ROOT .. ngx_var.APPNAME .. "/"
    local req = request:new(APPPATH)

    local lder = loader:new(APPNAME, APPPATH)
    local conf = lder:config('core')
    local debug_level = conf and conf.debug or 'DEBUG'
    local level = debug[debug_level]

    local dp = setmetatable({
        APPNAME = APPNAME,
        APPPATH = APPPATH,
        request = req,
        loader = lder,
        debug = debug:init(level, req, APPPATH)
    }, mt)
    ngx.ctx.dp = dp
    return dp
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

