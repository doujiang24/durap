-- Copyright (C) Dejiang Zhu (doujiang24)

local error = error
local _M = getfenv()


debug = "DEBUG"

default_ctr = "home"


sess_secure_key = "abcdefghigklmnopqrstuvwxyz123456"
sess_secure_iv = "abcefghigklmnopq"
sess_expire_time = "86400"

sess_cookie_key = "__luasess__"


local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

