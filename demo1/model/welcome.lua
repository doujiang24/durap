-- Copyright (C) Dejiang Zhu (doujiang24)

local mysql = require "system.database.mysql"

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

local _M =  {}
local mt = { __index = _M }

function _M.new(self)
    local dp = get_instance()
    local config = dp.loader:config('mysql')
    return setmetatable({ mysql = mysql:connect(config) }, mt)
end

function _M.create(self)
    local mysql = self.mysql
    local sql = [[
        DROP TABLE IF EXISTS `welcome`;
    ]]
    mysql:query(sql)
    local sql = [[
        CREATE TABLE `welcome` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(255) NOT NULL DEFAULT '',
        `dateline` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB;
    ]]
    return mysql:query(sql)
end

function _M.add(self, name)
    local mysql = self.mysql
    local setarr = {
        name = name,
        dateline = time()
    }
    return mysql:add(db_table, setarr)
end

function _M.count(self)
    local mysql = self.mysql
    return mysql:count(db_table)
end

function _M.list(self)
    local mysql = self.mysql
    return mysql:select("name"):where("name", "dou"):order_by("dateline", 'DESC'):get(db_table)
end

function _M.keepalive(self)
    local mysql = self.mysql
    return mysql:keepalive()
end

return _M
