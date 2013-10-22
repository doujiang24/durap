-- Copyright (C) 2013 doujiang24, MaMa Inc.

local ngx = ngx -- only for ngx.ctx
local ngx_var = ngx.var

local request = require "core.request"
local loader = require "core.loader"
local debug = require "core.debug"
local session = require "core.session"

local setmetatable = setmetatable
local get_instance = get_instance


local _M = { _VERSION = '0.01' }


local mt = { __index = _M }

function _M.init(self, level)
    local APPNAME = ngx_var.APPNAME
    local APPPATH = ngx_var.ROOT .. ngx_var.APPNAME .. "/"

    local dp = setmetatable({
        APPNAME = APPNAME,
        APPPATH = APPPATH
    }, mt)
    ngx.ctx.dp = dp
    return dp
end

local function _auto_load(table, key)
    local val = nil
    if key == "request" then
        val = request:new()

    elseif key == "debug" then
        val = debug:init()

    elseif key == "loader" then
        val = loader:new()

    elseif key == "session" then
        val = session:init()
    end

    local dp = get_instance()
    dp[key] = val
    return val
end

local class_mt = {
    __index = _auto_load
}

setmetatable(_M, class_mt)

return _M
