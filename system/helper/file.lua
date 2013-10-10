-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local corehelper = require "helper.core"

local log_error = corehelper.log_error
local find = string.find
local sub = string.sub
local insert = table.insert

local get_instance = get_instance
local io_open = io.open
local type = type
local concat = table.concat
local rename = os.rename
local time = ngx.time


local _M = { _VERSION = '0.01' }


function _M.tmpname(filename)
    return time() .. filename
end

function _M.move(source, dest)
    local ok, err = rename(source, dest)
    if not ok then
        log_error('move file err:', err, source, dest)
    end
    return ok
end

function _M.exists(f)
    local fh, err = io_open(f)
    if fh then
        fh:close()
        return true
    end
    return nil
end

function _M.log_file(file, ...)
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

function _M.read_all(filename)
    local file, err = io_open(filename, "r")
    local data = file and file:read("*a") or nil
    if file then
        file:close()
    end
    return data
end

return _M
