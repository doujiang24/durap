-- Copyright (C) 2013 MaMa

local mysql = require "database.mysql"

local setmetatable = setmetatable
local error = error
local time = ngx.localtime
local get_instance = get_instance

-- debug
local ngx = ngx
local type = type

_VERSION = '0.01'

-- constants
local db_table = "welcome"

local mt = { __index = getfenv() }

function new(self)
    local dp = get_instance()
    local config = dp.loader:config('mysql')
    return setmetatable({ mysql = mysql:connect(config) }, mt)
end

function add(self, name)
    local mysql = self.mysql
    local setarr = {
        name = name,
        dateline = time()
    }
    return mysql:add(db_table, setarr)
end

function count(self)
    local mysql = self.mysql
    return mysql:count(db_table)
end

function keepalive(self)
    local mysql = self.mysql
    return mysql:keepalive()
end
