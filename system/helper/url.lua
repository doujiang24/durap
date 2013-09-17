-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local ngx_header = ngx.header

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local exit = ngx.exit
local re_match = ngx.re.match
local ngx_redirect = ngx.redirect

local HTTP_MOVED_TEMPORARILY = ngx.HTTP_MOVED_TEMPORARILY

module(...)


function site_url(url)
    local host = get_instance().request.host
    return re_match(url, "^\\w+://", "i") and url or "http://" .. host .. "/" .. url
end

function redirect(url, status)
    local request = get_instance().request
    local url, status = site_url(url), status or HTTP_MOVED_TEMPORARILY
    return ngx_redirect(url, status)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

