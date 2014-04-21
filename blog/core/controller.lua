-- Copyright (C) Dejiang Zhu (doujiang24)

local cjson = require "cjson"
local urlhelper = require "system.helper.url"
local pagination = require "system.library.pagination"

local get_instance = get_instance
local tonumber = tonumber
local say = ngx.say
local redirect = urlhelper.redirect

local _M = {}

local function _get_user()
    local dp = get_instance()
    if dp.user == nil then
        local loader, session, user = dp.loader, dp.session, false
        local uid = session:get('uid')
        if uid and tonumber(uid) > 0 then
            local muser = loader:model('muser')
            user = muser:get(uid)
            muser:close()
        end
        dp.user = user
        return user
    end
    return dp.user
end
_M._get_user = _get_user

function _M._require_user()
    local user = _get_user()
    if not user then
        redirect('user/login')
    end
    return user
end

function _M._show(page, data)
    local dp = get_instance()
    local loader, router = dp.loader, dp.router
    data = data or {}
    data.title = "Blog"
    data.current_user = _get_user()
    data._uri = router:get_uri()
    data._page_ = page
    say(loader:view('page', data))
end

function _M._template(page, data)
    local dp = get_instance()
    local loader = dp.loader
    data = data or {}
    say(loader:view(page, data))
end

function _M._pagination(uri, total, size)
    local config = {
        base_url = uri,
        total_rows = total,
        per_page = size
    }
    return pagination.create_links(config)
end

return _M
