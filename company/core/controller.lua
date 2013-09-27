-- Copyright (C) 2013 MaMa

local cjson = require "cjson"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local say = ngx.say


local _M = getfenv()

function _return(data)
    say(cjson.encode(data))
end

function _show(page, data)
    local loader = get_instance().loader
    data = data or {}
    data._page_ = page
    say(loader:view('page', data))
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

