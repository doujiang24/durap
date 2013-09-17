-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local find = string.find
local sub = string.sub
local insert = table.insert

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local io_open = io.open
local type = type
local concat = table.concat

module(...)


function exists(f)
    local fh, err = io_open(f)
    if fh then
        fh:close()
        return true
    end
    return nil
end

function log_file(file, ...)
    local fp, err = io_open(file, "a")
    if not fp then
        local debug = get_instance().debug
        debug:log(debug.ERR, "failed to open file ", file)
        return
    end

    local args = { ... }
    for i = 1, #args do
        if args[i] == nil then
            args[i] = ""
        elseif type(args[i]) == "table" then
            args[i] = "table value"
        end
    end
    local str = concat(args, "\t")
    local ok, err = fp:write(str, "\n")
    if not ok then
        local debug = get_instance().debug
        debug:log(debug.ERR, "failed to write log file:", file, "str:", str)
        return
    end

    fp:close()
    return true
end

function read_all(filename)
    local file, err = io_open(filename, "r")
    local data = file and file:read("*a") or nil
    if file then
        file:close()
    end
    return data
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

