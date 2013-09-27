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

function index()
    _require_admin()

    local data = {}
    _show('blog', data)
end

function data()
    local dp = get_instance()
    local loader, request = dp.loader, dp.request
    local inputs = request:post()


    local size = inputs.rp or 20
    local start = inputs.page and (inputs.page - 1) * size or 0
    local search_key = inputs.query

    local blog = loader:model('mblog')
    local num = blog:count(search_key)
    local res = blog:lists(size, start, search_key)

    local data, rows = { page = inputs.page or 1, total = num }, {}
    for _i, v in ipairs(res) do
        insert(rows, { id = v.id, cell = v })
    end
    data.rows = rows
    _return(data)
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

