-- Copyright (C) 2013 doujiang24, MaMa Inc.

local null = ngx.null
local type = type
local ipairs = ipairs
local re_match = ngx.re.match


local _M = { _VERSION = '0.01' }


function _M.empty(...)
    local tbl = { ... }
    for _i, v in ipairs(tbl) do
        if v ~= "" and v ~= nil and v ~= null and v ~= false then
            return false
        end
    end
    return true
end

function _M.is_numeric(...)
    local tbl = { ... }
    for _i, v in ipairs(tbl) do
        if type(v) ~= "number" and
            (type(v) ~= "string" or re_match(v, "^-?\\d+.?\\d*$") == nil ) then
            return false
        end
    end
    return #tbl > 0 and true or false
end

function _M.is_string(...)
    local tbl = {...}
    for _i, v in ipairs(tbl) do
        if type(v) ~= "string" then
            return false
        end
    end
    return #tbl > 0 and true or false
end

return _M
