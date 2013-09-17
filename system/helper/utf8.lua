-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local setmetatable = setmetatable
local error = error
local insert = table.insert
local gsub = string.gsub
local gmatch = string.gmatch
local concat = table.concat
local select = select
local next = next
local print = print

module(...)

local utf8char = '[%z\1-\127\194-\244][\128-\191]*'

function len(s)
	return select(2, gsub(s, '[^\128-\193]', ''))
end

function sub(s, start, fend)
    fend = fend or -1
    fend = fend > 0 and fend or len(s) + fend
    start = start > 0 and start or len(s) + start + 1
    if start > fend then
        return ""
    end

    local ret = {}
    local i = 1

    for w in gmatch(s, utf8char) do
        if i >= start then
            insert(ret, w)
        end
        if i >= fend then
            break
        end
        i = i + 1
    end
    return next(ret) and concat(ret, "") or ""
end

function iter(str)
    return gmatch(str, utf8char)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

