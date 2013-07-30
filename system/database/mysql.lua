-- Copyright (C) 2013 MaMa

local mysql = require "resty.mysql"
local strhelper = require "helper.string"

local setmetatable = setmetatable
local insert = table.insert
local concat = table.concat
local quote_sql_str = ngx.quote_sql_str
local error = error
local pairs = pairs
local strip = strhelper.strip
local lower = string.lower
local str_find = string.find

-- debug
local ngx = ngx
local type = type
local cjson = require "cjson"

module(...)

_VERSION = '0.01'


local mt = { __index = _M }

-- local functions
local function _where(self, key, value, mod, escape)
    escape = (escape == nil) and true or escape
    local ar_where = self.ar_where

    if not (type(key) == "table") then
        key = { [key] = value }
    end

    for k, v in pairs(key) do
        k = strip(k)
        local where_arr = {}

        if #ar_where >= 1 then
            insert(where_arr, mod)
        end

        if str_find(k, " ") then
            insert(where_arr, k)
        else
            insert(where_arr, "`" .. k .. "` =")
        end

        if escape == false then
            insert(where_arr, v)
        else
            insert(where_arr, quote_sql_str(v))
        end

        insert(ar_where, concat(where_arr, " "))
    end
    return self
end

local function _where_in(self, key, values, boolean_in, mod)
    local ar_where = self.ar_where

    local where_arr = {}

    if #ar_where >= 1 then
        insert(where_arr, mod)
    end

    insert(where_arr, "`" .. k .. "`")

    if not boolean_in then
        insert(where_arr, "NOT")
    end
    insert(where_arr, "IN (")

    for i, v in ipairs(values) do
        values[i] = quote_sql_str(v)
    end
    insert(where_arr, concat(values, ", "))
    insert(where_arr, ")")

    insert(ar_where, concat(where_arr, " "))
    return self
end

local function _like(self, key, match, boolean_in, mod)
    local ar_where = self.ar_where

    local where_arr = {}

    if #ar_where >= 1 then
        insert(where_arr, mod)
    end

    insert(where_arr, "`" .. k .. "`")

    if not boolean_in then
        insert(where_arr, "NOT")
    end
    insert(where_arr, "LIKE")

    pattern = strip(quote_sql_str(match), "'")
    insert(where_arr, '"%' .. pattern .. '%"')

    insert(ar_where, concat(where_arr, " "))
    return self
end

local function _select_func(self, key, alias, func)
    local ar_select = self.ar_select
    local where_arr = {
        func,
        "(`",
        key,
        "`) as `",
        alias or (lower(func) .. "_" .. key),
        "`"
    }
    insert(ar_select, concat(where_arr))
    return self
end

local function _gen_where_sql(self)
    local ar_where = self.ar_where
    local ar_group_by = self.ar_group_by
    local ar_having = self.ar_having
    local ar_order_by = self.ar_order_by

    local sqlvars = {
        (#ar_where >= 1) and (" WHERE " .. concat(ar_where, " ")) or "",
        ar_group_by and (" GROUP BY " .. ar_group_by) or "",
        (#ar_having >= 1) and (" HAVING " .. concat(ar_having, " ")) or "",
        (#ar_order_by >= 1) and (" ORDER BY " .. concat(ar_order_by, " ")) or ""
    }
    return concat(sqlvars)
end

local function _reset_vars(self)
    self.ar_select = {}
    self.ar_set = {}
    self.ar_where = {}
    self.ar_having = {}
    self.ar_order_by = {}
    self.ar_group_by = nil
    self.ar_limit = nil
    self.ar_offset = nil
end
-- end local functions

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

    _reset_vars(mysql)
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
        _gen_where_sql(self)
    }
    local sql = concat(sqlvars, "")

    local res = self:query(sql)
    return res[1].num
end

function get(self, table, lmt, offset)
    local _ = lmt and limit(self, lmt, offset)
    local ar_select, ar_limit, ar_offset = self.ar_select, self.ar_limit, self.ar_offset

    local sqlvars = {
        "SELECT ",
        (#ar_select >= 1) and concat(ar_select, ", ") or "*",
        " FROM `",
        table,
        "` ",
        _gen_where_sql(self),
        ar_limit and (" LIMIT " .. ar_offset .. ", " .. ar_limit) or ""
    }
    local sql = concat(sqlvars)
    _reset_vars(self)
    return query(self, sql)
end

function get_where(self, table, wherearr, limit, offset)
    where(self, wherearr)
    return get(self, table, limit, offset)
end

function update(self, table, setarr, wherearr)
    local ar_set, ar_limit = self.ar_set, self.ar_limit
    local sqlvars = {
        "UPDATE `",
        table,
        "` ",
        " SET ",
        concat(ar_set, ", "),
        _gen_where_sql(self),
        ar_limit and (" LIMIT " .. ar_limit) or ""
    }
    local sql = concat(sqlvars)
    _reset_vars(self)
    return query(self, sql)
end

function delete(self, table, wherearr)
    local ar_limit = self.ar_limit
    local sqlvars = {
        "DELETE FROM `",
        table,
        "` ",
        _gen_where_sql(self),
        ar_limit and (" LIMIT " .. ar_limit) or ""
    }
    local sql = concat(sqlvars)
    _reset_vars(self)
    return query(self, sql)
end

function truncate(self, table)
    local sql = "TRUNCATE TABLE `" ..  table .. "`"
    return query(self, sql)
end

function query(self, sql)
    local conn = self.conn
    ngx.say(sql)
    ngx.say("<br>")

    local res, err, errno, sqlstate = conn:query(sql)
    if not res then
        -- logger:log(logger.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ": sql:", sql, ": ", ".")
        ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ": sql:", sql, ": ", ".")
        return nil
    end

    return res
end

-- where functions
function where(self, key, value, escape)
    escape = (escape == nil) and true or escape
    return _where(self, key, value, "AND", escape)
end

function or_where(self, key, value, escape)
    escape = (escape == nil) and true or escape
    return _where(self, key, value, "OR", escape)
end

function where_in(self, key, values)
    return _where_in(self, key, values, true, 'AND')
end

function where_not_in(self, key, values)
    return _where_in(self, key, values, false, 'AND')
end

function or_where_in(self, key, values)
    return _where_in(self, key, values, true, 'OR')
end

function or_where_not_in(self, key, values)
    return _where_in(self, key, values, false, 'OR')
end

function like(self, key, pattern)
    return _like(self, key, match, true, 'AND')
end

function not_like(self, key, pattern)
    return _like(self, key, match, false, 'AND')
end

function or_like(self, key, pattern)
    return _like(self, key, match, true, 'OR')
end

function or_not_like(self, key, pattern)
    return _like(self, key, match, false, 'OR')
end
-- end where functions


-- select functions
function select(self, key, escape)
    escape = (escape == nil) and true or escape
    local ar_select = self.ar_select
    if escape then
        key = "`" .. key .. "`"
    end
    insert(ar_select, key)
    return self
end

function select_max(self, key, alias)
    return _select_func(self, key, alias, "MAX")
end

function select_min(self, key, alias)
    return _select_func(self, key, alias, "MIN")
end

function select_avg(self, key, alias)
    return _select_func(self, key, alias, "AVG")
end

function select_sum(self, key, alias)
    return _select_func(self, key, alias, "SUM")
end

function select_count(self, key, alias)
    return _select_func(self, key, alias, "COUNT")
end
-- end select function

function limit(self, limit, offset)
    self.ar_limit = limit
    self.ar_offset = offset or 0
    return self
end

function set(self, key, value, escape)
    escape = (escape == nil) and true or escape
    local ar_set = self.ar_set

    local set_arr = {
        "`", key, "` = ",
        escape and quote_sql_str(value) or value
    }

    insert(ar_set, concat(set_arr))
    return self
end

function order_by(self, key, order)
    order = order or "DESC"
    local ar_order_by = self.ar_order_by

    local order_arr = { "`", key, "` ", order }
    insert(ar_order_by, concat(order_arr))
    return self
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

