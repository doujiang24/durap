-- Copyright (C) Dejiang Zhu (doujiang24)

local mysql = require "database.mysql"
local tblhelper = require "helper.table"
local resty_radom = require "resty.random"
local resty_str = require "resty.string"

local setmetatable = setmetatable
local error = error
local get_instance = get_instance
local in_tbl = tblhelper.in_tbl
local md5 = ngx.md5


_VERSION = '0.01'

-- constants
local db_table = "blog"


local _M = getfenv()
local mt = { __index = _M }


function new(self)
    local dp = get_instance()
    local config = dp.loader:config('mysql')
    return setmetatable({ mysql = mysql:connect(config) }, mt)
end

function add(self, title, content, uid)
    local mysql = self.mysql

    local setarr = {
        uid = uid,
        title = title,
        content = content
    }

    return mysql:add(db_table, setarr)
end

-- key is uid or username; default uid
function get(self, id)
    local mysql = self.mysql

    mysql:where('id', id):where('status', 1)
    return mysql:first_row(mysql:get(db_table))
end

function count(self)
    local mysql = self.mysql

    return mysql:where('status', 1):count(db_table)
end

function lists(self, size, start)
    local mysql = self.mysql

    return mysql:where('status', 1):limit(size, start):order_by('id', 'DESC'):get(db_table) or {}
end

function close(self)
    local mysql = self.mysql
    return mysql:keepalive()
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

