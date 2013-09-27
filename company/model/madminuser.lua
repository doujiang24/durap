-- Copyright (C) 2013 MaMa

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
local db_table = "admin_user"


local _M = getfenv()
local mt = { __index = _M }

local function _salt()
    local random = resty_radom.bytes(2)
    return resty_str.to_hex(random)
end

local function _password(password, salt)
    return md5(md5(password) .. salt)
end

function new(self)
    local dp = get_instance()
    local config = dp.loader:config('mysql')
    return setmetatable({ mysql = mysql:connect(config) }, mt)
end

function add(self, username, password)
    local mysql = self.mysql

    if not username and not password then
        local debug = get_instance().debug
        debug:log(debug.ERR, 'username or password is not valid:', username, password)
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
function get(self, value, key)
    key = key == "username" and key or "uid"
    local mysql = self.mysql

    mysql:where(key, value):where('status', 1)
    return mysql:first_row(mysql:get(db_table))
end

function login(self, username, password)
    local mysql = self.mysql

    local user = get(self, username, 'username')
    return user and user.password == _password(password, user.salt) and
        user or false
end

function repass(self, uid, password)
    local mysql = self.mysql

    local user = get(self, uid)
    local password = _password(password, user.salt)

    return mysql:update(db_table, { password = password }, { uid = uid })
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

