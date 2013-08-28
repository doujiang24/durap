-- Copyright (C) 2013 MaMa

local utf8 = require "helper.utf8"
local bit = require "bit"

local band = bit.band
local rshift = bit.rshift
local bor = bit.bor
local tonumber = tonumber
local chr = string.char
local insert = table.insert
local concat = table.concat

local setmetatable = setmetatable
local error = error

module(...)

-- unicode to utf8
function u2utf8(char)
    local ret = {}
    local num = tonumber(char)
    if num < 0x80 then
        insert(ret, chr(num))
    elseif num < 0x800 then
        insert(ret, chr(bor(0xC0, rshift(num, 6))))
        insert(ret, chr(bor(0x80, band(num, 0x3F))))
    elseif num < 0x10000 then
        insert(ret, chr(bor(0xE0, rshift(num, 12))))
        insert(ret, chr(bor(0x80, band(rshift(num, 6), 0x3F))))
        insert(ret, chr(bor(0x80, band(num, 0x3F))))
    elseif num < 0x200000 then
        insert(ret, chr(bor(0xF0, rshift(num, 18))))
        insert(ret, chr(bor(0x80, band(rshift(num, 12), 0x3F))))
        insert(ret, chr(bor(0x80, band(rshift(num, 6), 0x3F))))
        insert(ret, chr(bor(0x80, band(num, 0x3F))))
    end
    return concat(ret)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

