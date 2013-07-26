-- Copyright (C) 2013 MaMa

local strhelper = require "helper.string"

local get_instance = get_instance

local setmetatable = setmetatable
local error = error

local say = ngx.say
local type = type


module(...)

local mt = { __index = _M }

local function _fetch_uri_string(self)
    local str = self.uri
    self.segments = strhelper.split(strhelper.strip(str, "/"), "/")
end

function new(self)
    local dp = get_instance()
    local uri = dp.request.uri

    return setmetatable({
        apppath = dp.APPPATH,
        uri = uri,
        segments = nil
    }, mt)
end

function set_router(self)
    _fetch_uri_string(self)
    local segments = self.segments

    if #segments > 0 then
        local ctr = dp.loader.controller(segments[1])
        if ctr then
            local func = segments[2]
            remove(segments, 2)
            remove(segments, 1)
            return ctr, func, segments

        else
            local ctr = dp.loader.controller(concat(segments[1], "/", segments[2]))

        end

        if file.exists( concat({ self.apppath, "controller/", segments[1], ".lua" }) ) then
    else
        -- dp.log()
        return nil
    end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)
