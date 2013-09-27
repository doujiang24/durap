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

function _get_adminuser()
    local dp = get_instance()
    if dp.admin_user == nil then
        local loader, session, user = dp.loader, dp.request:session(), false
        local admin_uid = session.admin_uid
        if admin_uid and tonumber(admin_uid) > 0 then
            local madminuser = loader:model('madminuser')
            local adminuser = madminuser:new()
            user = adminuser:get(session.admin_uid)
            adminuser:close()
        end
        dp.admin_user = user
        return user
    end
    return dp.admin_user
end

function _require_admin()
    local admin = _get_adminuser()
    if not admin then
        redirect('admin/user/login')
    end
    return admin
end

function _return(data)
    say(cjson.encode(data))
end

function _show(page, data)
    local dp = get_instance()
    local loader, router = dp.loader, dp.router
    data = data or {}
    data.title = "后台管理"
    data.admin_user = _get_adminuser()
    data._uri = router:get_uri()
    data._page_ = "admin/" .. page
    say(loader:view('admin/page', data))
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

