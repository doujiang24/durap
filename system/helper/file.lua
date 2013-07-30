-- Copyright (C) 2013 MaMa

local find = string.find
local sub = string.sub
local insert = table.insert

local setmetatable = setmetatable
local error = error
local io_open = io.open

module(...)


function exists(f)
    local fh, err = io_open(f)
    if fh then
        fh:close()
        return true
    end
    return nil
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

