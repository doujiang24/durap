-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local concat = table.concat
local type = type
local sub = string.sub

local setmetatable = setmetatable
local error = error

module(...)

local h2d = {
    ['0'] = 0,
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    ['a'] = 10,
    ['b'] = 11,
    ['c'] = 12,
    ['d'] = 13,
    ['e'] = 14,
    ['f'] = 15,
    ['A'] = 10,
    ['B'] = 11,
    ['C'] = 12,
    ['D'] = 13,
    ['E'] = 14,
    ['F'] = 15,
}

-- hex to decimal (hex is a string, return a number)
function h2dec(hex)
    local len = #hex
    local ret = 0
    for i = 1, len do
        local c = sub(hex, i, i)
        ret = ret + h2d[c] * 16 ^ (len - i)
    end
    return ret
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

