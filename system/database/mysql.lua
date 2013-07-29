-- Copyright (C) 2013 MaMa

local mysql = require "resty.mysql"

local setmetatable = setmetatable
local insert = table.insert
local concat = table.concat
local quote_sql_str = ngx.quote_sql_str
local error = error
local pairs = pairs

-- debug
local ngx = ngx
local type = type
local cjson = require "cjson"

module(...)

_VERSION = '0.01'


local mt = { __index = _M }

function connect(self, config)
    local mysql = setmetatable({ conn = mysql:new(), config = config }, mt)

    local conn = mysql.conn

    conn:set_timeout(config.timeout)

    local ok, err, errno, sqlstate = conn:connect({
        host = config.host,
        port = config.port,
        database = config.database,
        user = config.user,
        password = config.password,
        max_packet_size = config.max_packet_size
    })

    if not ok then
        -- logger:log(logger.ERR, "failed to connect: ", err, ": ", errno, " ", sqlstate)
        ngx.log(ngx.ERR, "failed to connect: ", err, ": ", errno, " ", sqlstate)
        return
    end

    return mysql
end

function add(self, table, setarr)
    local keys, values = {}, {}
    for key, val in pairs(setarr) do
        insert(keys, key)
        insert(values, quote_sql_str(val))
    end
    local sqlvars = {
        "insert into `",
        table,
        "` (`",
        concat(keys, "`, `"),
        "`) values (",
        concat(values, ", "),
        ")"
    }
    local sql = concat(sqlvars, "")

    local res = self:query(sql)
    return res and res.insert_id
end

function count(self, table, wherearr)
    local sqlvars = {
        "select count(*) as num from `",
        table,
        "` where ",
        _gen_where_sql()
    }
    local sql = concat(sqlvars, "")

    local res = self:query(sql)
    return res[1].num
end

-- to do
function where(self, key_or_table, value)
end

-- to do
function _gen_where_sql()
    return "1";
end

function query(self, sql)
    local conn = self.conn

    local res, err, errno, sqlstate = conn:query(sql)
    if not res then
        -- logger:log(logger.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ": sql:", sql, ": ", ".")
        ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ": sql:", sql, ": ", ".")
        return nil
    end

    return res
end


function keepalive(self)
    local conn = self.conn
    local max_keepalive = self.config.max_keepalive
    local ok, err = conn:set_keepalive(0, max_keepalive)
        if not ok then
            -- logger:log(logger.ERR, "failed to set redis keepalive: ", err)
        return
    end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

