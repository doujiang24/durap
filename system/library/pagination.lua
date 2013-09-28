-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local get_instance = get_instance

local setmetatable = setmetatable
local error = error

module(...)


function initialize(config)
end

function create_links(baseUrl, total, pagesize)
end


local class_mt = {
    __index = get_instance().loader:core('controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

