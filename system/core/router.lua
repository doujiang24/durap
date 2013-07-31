-- Copyright (C) 2013 MaMa

local strhelper = require "helper.string"

local get_instance = get_instance

local setmetatable = setmetatable
local error = error
local concat = table.concat
local remove = table.remove
local type = type


module(...)

local mt = { __index = _M }

local function _fetch_uri_string(self)
    local str = self.uri
    self.segments = strhelper.split(strhelper.strip(str, "/"), "/")
end

function new(self)
    local dp = get_instance()

    return setmetatable({
        loader = dp.loader,
        apppath = dp.APPPATH,
        debug = dp.debug,
        uri = dp.request.uri,
        segments = nil
    }, mt)
end

function route(self)
    _fetch_uri_string(self)
    local loader, segments, debug = self.loader, self.segments, self.debug

    if #segments > 0 then
        local ctr = loader:controller(segments[1])
        if ctr then
            local func = segments[2]
            if func and type(ctr[func]) == "function" then
                remove(segments, 2)
                remove(segments, 1)
                return ctr, func, segments
            end
        else
            local ctr = loader:controller(concat({segments[1], "/", segments[2]}))
            if ctr then
                local func = segments[3]
                if func and type(ctr[func]) == "function" then
                    remove(segments, 3)
                    remove(segments, 2)
                    remove(segments, 1)
                    return ctr, func, segments
                end
            end
        end
    end
    debug:log(debug.ERR, "router failed")
    return nil
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

