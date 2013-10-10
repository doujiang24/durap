-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local ngx_header = ngx.header

local get_instance = get_instance
local exit = ngx.exit
local re_match = ngx.re.match
local ngx_redirect = ngx.redirect

local HTTP_MOVED_TEMPORARILY = ngx.HTTP_MOVED_TEMPORARILY


local _M = { _VERSION = '0.01' }


function _M.site_url(url)
    local host = get_instance().request.host
    return re_match(url, "^\\w+://", "i") and url or "http://" .. host .. "/" .. url
end

function _M.redirect(url, status)
    local request = get_instance().request
    local url, status = _M.site_url(url), status or HTTP_MOVED_TEMPORARILY
    return ngx_redirect(url, status)
end

return _M
