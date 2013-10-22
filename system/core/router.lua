-- Copyright (C) 2013 doujiang24, MaMa Inc.

local strhelper = require "helper.string"
local tblhelper = require "helper.table"
local corehelper = require "helper.core"

local get_instance = get_instance

local setmetatable = setmetatable
local concat = table.concat
local type = type
local unpack = unpack
local strip = strhelper.strip
local split = strhelper.split
local slice = tblhelper.slice
local insert = table.insert
local log_error = corehelper.log_error


local _M = { _VERSION = '0.01' }


local max_level = 2
local default_func = "index"
local remap_func = "_remap"
local default_ctr = "index"


local mt = { __index = _M }

function _M.get_segments(self)
    if not self.segments then
        local str = self.uri
        self.segments = split(strip(str, "/"), "/")
    end
    return self.segments
end

function _M.new(self)
    local dp = get_instance()

    return setmetatable({
        loader = dp.loader,
        apppath = dp.APPPATH,
        uri = dp.request.uri,
        segments = nil
    }, mt)
end

function _M.route(self)
    local loader = self.loader
    local segments = _M.get_segments(self)
    local conf = loader:config('core')
    local default_ctr = conf and conf.default_ctr or default_ctr

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

function _M.get_uri(self)
    local segments = _M.get_segments(self)
    return concat(segments, "/")
end

return _M
