-- Copyright (C) Dejiang Zhu (doujiang24)

local urlhelper = require "system.helper.url"

local get_instance = get_instance
local redirect = urlhelper.redirect
local _show = get_instance().loader:core('controller')._show

local _M = {}

function _M.register()
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

function _M.login()
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

function _M.logout()
    local session = get_instance().session
    session:set('uid', nil)
    redirect('')
end

return _M
