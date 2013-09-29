-- Copyright (C) 2013 MaMa

local error = error
local _M = getfenv()


debug = "DEBUG"

default_ctr = "home"

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

