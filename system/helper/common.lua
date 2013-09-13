-- Copyright (C) 2013 MaMa

local setmetatable = setmetatable
local error = error
local null = ngx.null
local type = type
local ipairs = ipairs
local re_match = ngx.re.match


module(...)


function empty(...)
    local tbl = { ... }
    for _i, v in ipairs(tbl) do
        if v ~= "" and v ~= nil and v ~= null and v ~= false then
            return false
        end
    end
    return true
end

function is_numeric(...)
    local tbl = { ... }
    for _i, v in ipairs(tbl) do
        if type(v) ~= "number" and
            (type(v) ~= "string" or re_match(v, "^-?\\d+.?\\d*$") == nil ) then
            return false
        end
    end
    return #tbl > 0 and true or false
end

function is_string(...)
    local tbl = {...}
    for _i, v in ipairs(tbl) do
        if type(v) ~= "string" then
            return false
        end
    end
    return #tbl > 0 and true or false
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

