-- Copyright (C) 2013 MaMa

local error = error
local _M = getfenv()


timeout = 3000

host = "127.0.0.1"
port = "3306"
database = "ngx_test"
user = "ngx_test"
password = "ngx_test"
max_packet_size = 1024 * 1024

max_keepalive = 100

charset = "utf8"

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

