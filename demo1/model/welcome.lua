-- Copyright (C) Dejiang Zhu (doujiang24)

local mysql = require "system.database.mysql"

local setmetatable = setmetatable
local time = ngx.localtime
local get_instance = get_instance


-- constants
local config    = get_instance().loader:config('mysql')
local db_table  = "welcome"

local _M =  {}
local mt = { __index = _M }


function _M.new(self)
    local db = mysql:connect(config)

    if db then
        return setmetatable({ db = db }, mt)
    end
end

function _M.create(self)
    local db = self.db
    local sql = [[
        DROP TABLE IF EXISTS `welcome`;
    ]]
    db:query(sql)
    local sql = [[
        CREATE TABLE `welcome` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(255) NOT NULL DEFAULT '',
        `dateline` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB;
    ]]
    return db:query(sql)
end

function _M.add(self, name)
    local db = self.db
    local setarr = {
        name = name,
        dateline = time()
    }
    return db:add(db_table, setarr)
end

function _M.count(self)
    local db = self.db
    return db:count(db_table)
end

function _M.list(self)
    local db = self.db
    return db:select("name"):where("name", "dou"):order_by("dateline", 'DESC'):get(db_table)
end

function _M.close(self)
    local db = self.db
    return db:keepalive()
end

return _M

