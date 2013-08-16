-- Copyright (C) 2013 MaMa

local find = string.find
local sub = string.sub
local insert = table.insert

local setmetatable = setmetatable
local error = error

module(...)


-- @param pattern The split pattern (I.e. "%s+" to split text by one or more
-- whitespace characters).
function split(s, pattern, ret)
    if not pattern then pattern = "%s+" end
    if not ret then ret = {} end
    local pos = 1
    local fstart, fend = find(s, pattern, pos)
    while fstart do
        insert(ret, sub(s, pos, fstart - 1))
        pos = fend + 1
        fstart, fend = find(s, pattern, pos)
    end
    if pos <= #s then
        insert(ret, sub(s, pos))
    end
    return ret
end

-- @param pattern The pattern to strip from the left-most and right-most of the
function strip(s, pattern)
    local p = pattern or "%s*"
    local sub_start, sub_end

    -- Find start point
    local _, f_end = find(s, "^"..p)
    if f_end then sub_start = f_end + 1 end

    -- Find end point
    local f_start = find(s, p.."$")
    if f_start then sub_end = f_start - 1 end

    return sub(s, sub_start or 1, sub_end or #s)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

