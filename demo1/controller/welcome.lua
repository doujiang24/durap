-- Copyright (C) Dejiang Zhu (doujiang24)

local get_instance  = get_instance
local type          = type
local tonumber      = tonumber
local ngx_say       = ngx.say


local _M = {}


function _M.hello(name)
    ngx_say('say hello, ', name, ".")
end

function _M.database()
    local welcome = get_instance().loader:model('welcome')
    if not welcome then
        return ngx_say('mysql error')
    end

    local res = welcome:create()
    if res then
        ngx_say('table welcome created.')
    end

    local res = welcome:add('dou')
    if res then
        ngx_say('new one added.')
    end

    local total = welcome:count()
    local res = welcome:list()

    welcome:close()

    if tonumber(total) == #res then
        ngx_say('count num match list count.')
    end
end

function _M.redis(name)
    local redis = get_instance().loader:model('redis')
    if not redis then
        return ngx_say('redis error')
    end

    local res = redis:add(name)
    if res then
        ngx_say('add success')
    end

    local res = redis:get()
    if res then
        ngx_say('get success')
    end

    redis:close()

    if res == name then
        ngx_say('get match the add')
    end
end

return _M

