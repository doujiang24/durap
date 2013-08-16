-- Copyright (C) 2013 MaMa

local setmetatable = setmetatable
local error = error
local pairs = pairs
local insert = table.insert
local type = type

module(...)


function filter(tbl, func)
    local ret = {}
    for k, v in pairs(tbl) do
        if not func(v) then
            ret[k] = v
        end
    end
    return ret
end

function in_tbl(value, tbl)
    for _k, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return nil
end

function copy(tbl)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[k] = v
    end
    return ret
end

-- append: append tbl2 to tbl1 when is true; default nil
function merge(tbl1, tbl2, append)
    local ret = tbl1
    if not append then
        ret = copy(tbl1)
    end

    for k, v in pairs(tbl2) do
        if type(k) == "number" then
            insert(ret, v)
        else
            ret[k] = v
        end
    end
    return ret
end

function slice(tbl, offset, length)
    local ret = {}
    local fend = length and ((offset + length) <= #tbl) and (offset + length - 1) or #tbl
    for i = offset, fend, 1 do
        insert(ret, tbl[i])
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

