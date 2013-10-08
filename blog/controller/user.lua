-- Copyright (C) 2013 MaMa

local urlhelper = require "helper.url"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local redirect = urlhelper.redirect

local _M = getfenv()

function register()
    local dp = get_instance()
    local loader, request, session = dp.loader, dp.request, dp.session
    local posts = request:post()
    local username, password = posts.username, posts.password

    local data
    if username and password then
        local muser = loader:model('muser')
        local uid = muser:add(username, password)
        muser:close()

        if uid then
            session:set('uid', uid)
            return redirect('')
        else
            data = { msg = 'failed, may be the username have been registered !' }
        end
    end
    _show('register', data)
end

function login()
    local dp = get_instance()
    local loader, request, session = dp.loader, dp.request, dp.session
    local posts = request:post()
    local username, password = posts.username, posts.password

    if username and password then
        local muser = loader:model('muser')
        local user = muser:login(username, password)
        muser:close()

        if user then
            session:set('uid', user.uid)
            redirect('')
        else
            local data = { msg = 'username or password error!' }
            _show('login', data)
        end
    else
        _show('login')
    end
end

function logout()
    local session = get_instance().session
    session:set('uid', nil)
    redirect('')
end

local class_mt = {
    __index = get_instance().loader:core('controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

