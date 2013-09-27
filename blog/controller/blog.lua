-- Copyright (C) 2013 MaMa

local urlhelper = require "helper.url"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local redirect = urlhelper.redirect
local ipairs = ipairs
local insert = table.insert
local ngx = ngx

local _M = getfenv()

function _remap(start)
    local dp = get_instance()
    local loader = dp.loader

    local start, size = start or 0, 20
    local blog = loader:model('mblog')
    local num = blog:count()
    local res = blog:lists(size, start)

    local data = { total = num, lists = res }
    _show('blog', data)
end

function publish()
    local ret = {}

    local dp = get_instance()
    local loader, request = dp.loader, dp.request
    local posts = request:post()

    if posts.submit then
    end
    _show('publish', ret)
end

local class_mt = {
    __index = get_instance().loader:core('controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

