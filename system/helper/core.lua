-- Copyright (C) 2013 MaMa

local get_instance = get_instance

local setmetatable = setmetatable
local error = error
local say = ngx.say
local exit = ngx.exit
local HTTP_INTERNAL_SERVER_ERROR = ngx.HTTP_INTERNAL_SERVER_ERROR

module(...)

function show_error(err_msg, ...)
    local debug = get_instance().debug
    debug:log(debug.ERR, err_msg, ...)
    say(err_msg)
    exit(HTTP_INTERNAL_SERVER_ERROR)
end

function log_debug(...)
    local debug = get_instance().debug
    return debug:log(debug.DEBUG, ...)
end

function log_error(...)
    local debug = get_instance().debug
    return debug:log(debug.ERR, ...)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)
