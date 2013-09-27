-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local strhelper = require "helper.string"
local tblhelper = require "helper.table"
local corehelper = require "helper.core"

local get_instance = get_instance

local setmetatable = setmetatable
local error = error
local concat = table.concat
local type = type
local unpack = unpack
local strip = strhelper.strip
local split = strhelper.split
local slice = tblhelper.slice
local insert = table.insert
local log_error = corehelper.log_error


module(...)

local max_level = 2
local default_func = "index"
local remap_func = "_remap"
local default_ctr = "index"


local mt = { __index = _M }

local function _fetch_uri_string(self)
    local str = self.uri
    self.segments = split(strip(str, "/"), "/")
end

function new(self)
    local dp = get_instance()

    return setmetatable({
        loader = dp.loader,
        apppath = dp.APPPATH,
        uri = dp.request.uri,
        segments = nil
    }, mt)
end

function route(self)
    _fetch_uri_string(self)
    local loader, segments = self.loader, self.segments
    local default_ctr = loader:config('core').default_ctr or default_ctr

    if #segments == 0 then
        insert(segments, default_ctr)
    end
    local fend = (#segments > max_level) and max_level or #segments
    for i = 1, fend do
        local ctr = loader:controller(concat(slice(segments, 1, i), "/"))
        if not ctr and not segments[i+1] then
            insert(segments, default_ctr)
            ctr = loader:controller(concat(slice(segments, 1, i+1), "/"))
        end
        if ctr then
            local func = segments[i+1]
            if func and type(ctr[func]) == "function" then
                return ctr, func, slice(segments, i+2)
            elseif type(ctr[remap_func]) == "function" then
                return ctr, remap_func, slice(segments, i+1)
            elseif not func and type(ctr[default_func]) == "function" then
                return ctr, default_func, {}
            end
        end
    end
    log_error("router failed", unpack(segments))
    return nil
end

function get_uri(self)
    local segments = self.segments
    return concat(segments, "/")
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

