-- Copyright (C) 2013 MaMa

local cjson = require "cjson"
local urlhelper = require "helper.url"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local tonumber = tonumber
local say = ngx.say
local redirect = urlhelper.redirect


local _M = getfenv()

function _return(data)
    say(cjson.encode(data))
end

function _get_user()
    local dp = get_instance()
    if dp.user == nil then
        local loader, session, user = dp.loader, dp.request:session(), false
        local uid = session.uid
        if uid and tonumber(uid) > 0 then
            local muser = loader:model('muser')
            user = muser:get(session.uid)
            muser:close()
        end
        dp.user = user
        return user
    end
    return dp.user
end

function _require_login()
    local user = _get_user()
    if not user then
        redirect('user/login')
    end
    return user
end

function _show(page, data)
    local dp = get_instance()
    local loader, router = dp.loader, dp.router
    data = data or {}
    data.title = "Blog"
    data.current_user = _get_user()
    data._uri = router:get_uri()
    data._page_ = page
    say(loader:view('page', data))
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

