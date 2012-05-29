-- Copyright

module("core.mysql", package.seeall)

-- global variables
local mysql = require "resty.mysql"
local db

function init()
    db = mysql:new()
    db:set_timeout(1000) -- 1 sec
    local ok, err, errno, sqlstate = db:connect {
        host = "127.0.0.1",
        port = 3306,
        database = "ngx_test",
        user = "root",
        password = "",
        max_packet_size = 1024 * 1024
    }
    if not ok then
        ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
        ngx.exit(500)
    end
end

function select()
    res, err, errno, sqlstate =
    db:query("select * from cats order by id asc")
    if not res then
        ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
        return
    end

    local cjson = require "cjson"
    ngx.say("result: ", cjson.encode(res))
end

function close()
    local ok, err = db:set_keepalive(0, 100)
    if not ok then
        ngx.say("failed to set keepalive: ", err)
        return
    end
end

-- or connect to a unix domain socket file listened
-- by a mysql server:
--     local ok, err, errno, sqlstate =
--           db:connect{
--              path = "unix:/path/to/mysql.sock",
--              database = "ngx_test",
--              user = "ngx_test",
--              password = "ngx_test" }


--[[
if not ok then
    ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
    return
end

ngx.say("connected to mysql.")

local res, err, errno, sqlstate =
db:query("drop table if exists cats")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

res, err, errno, sqlstate =
db:query("create table cats "
.. "(id serial primary key, "
.. "name varchar(5))")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

ngx.say("table cats created.")

res, err, errno, sqlstate =
db:query("insert into cats (name) "
.. "values (\'Bob\'),(\'\'),(null)")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

ngx.say(res.affected_rows, " rows inserted into table cats ",
"(last insert id: ", res.insert_id, ")")

res, err, errno, sqlstate =
db:query("select * from cats order by id asc")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

local cjson = require "cjson"
ngx.say("result: ", cjson.encode(res))

--]]

-- put it into the connection pool of size 100,
-- with 0 idle timeout

-- or just close the connection right away:
-- local ok, err = db:close()
-- if not ok then
--     ngx.say("failed to close: ", err)
--     return
-- end
