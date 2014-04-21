-- Copyright (C) Dejiang Zhu (doujiang24)

local mysql = require "system.database.mysql"
local tblhelper = require "system.helper.table"
local resty_radom = require "resty.random"
local resty_str = require "resty.string"
local corehelper = require "system.helper.core"

local get_instance = get_instance
local in_tbl = tblhelper.in_tbl
local md5 = ngx.md5
local log_error = corehelper.log_error


_VERSION = '0.01'

-- constants
local db_table = "users"


local _M = {}
local mt = { __index = _M }

local function _salt()
    local random = resty_radom.bytes(2)
    return resty_str.to_hex(random)
end

local function _password(password, salt)
    return md5(md5(password) .. salt)
end

function _M.new(self)
    local dp = get_instance()
    local config = dp.loader:config('mysql')
    return setmetatable({ mysql = mysql:connect(config) }, mt)
end

function _M.add(self, username, password)
    local mysql = self.mysql

    if not username and not password then
        log_error('username or password is not valid:', username, password)
        return nil
    end

    local salt = _salt()
    password = _password(password, salt)
    local setarr = {
        username = username,
        password = password,
        salt = salt
    }

    return mysql:add(db_table, setarr)
end

-- key is uid or username; default uid
local function get(self, value, key)
    key = key == "username" and key or "uid"
    local mysql = self.mysql

    mysql:where(key, value):where('status', 1)
    return mysql:first_row(mysql:get(db_table)) or false
end
_M.get = get

function _M.login(self, username, password)
    local mysql = self.mysql

    local user = get(self, username, 'username')
    return user and user.password == _password(password, user.salt) and
        user or false
end

function _M.close(self)
    local mysql = self.mysql
    return mysql:keepalive()
end

return _M
