-- Copyright (C) 2013 MaMa

local urlhelper = require "helper.url"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local redirect = urlhelper.redirect

local _M = getfenv()

function index()
    local dp = get_instance()
    local loader, request = dp.loader, dp.request
    local posts = request:post()
    local username, password = posts.username, posts.password

    _show('index')
end

function logout()
    local request = get_instance().request
    request:set_session('admin_uid', 0)
    redirect('admin/user/login')
end

local class_mt = {
    __index = get_instance().loader:core('admin_controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

