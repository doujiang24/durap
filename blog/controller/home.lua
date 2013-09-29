-- Copyright (C) 2013 MaMa

local urlhelper = require "helper.url"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local redirect = urlhelper.redirect

local _M = getfenv()

function index()
    _show('index')
end

function about()
    _show('about')
end

local class_mt = {
    __index = get_instance().loader:core('controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

