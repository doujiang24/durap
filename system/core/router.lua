-- Copyright (C) 2013 MaMa

local strhelper = require "helper.string"

local get_instance = get_instance

local setmetatable = setmetatable
local error = error
local concat = table.concat
local remove = table.remove

--- debug
local ngx = ngx
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
        loader = dp.loader,
        apppath = dp.APPPATH,
        uri = uri,
        segments = nil
    }, mt)
end

function set_router(self)
    _fetch_uri_string(self)
    local segments = self.segments
    local loader = self.loader

    if #segments > 0 then
        local ctr = loader:controller(segments[1])
        if ctr then
            local func = segments[2]
            remove(segments, 2)
            remove(segments, 1)
            return ctr, func, segments

        else
            local ctr = loader:controller(concat({segments[1], "/", segments[2]}))
            local func = segments[3]
            remove(segments, 3)
            remove(segments, 2)
            remove(segments, 1)
            return ctr, func, segments

        end
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
