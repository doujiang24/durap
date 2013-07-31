-- Copyright (C) 2013 MaMa

local file = require "helper.file"

local setmetatable = setmetatable
local getmetatable = getmetatable
local rawget = rawget
local error = error
local pcall = pcall
local assert = assert
local loadfile = loadfile
local setfenv = setfenv
local concat = table.concat

local _G = _G


module(...)

_VERSION = '0.01'


local mt = { __index = _M }


function new(self, appname, apppath, debug)
    local res = {
        appname = appname,
        apppath = apppath,
        debug = debug
    }
    return setmetatable(res, mt)
end

local function _get_cache(self, module)
    local appname, debug = self.appname, self.debug
    local cache_module = _G.cache_module
    if cache_module[appname] and cache_module[appname][module] then
        debug:log(debug.DEBUG, 'load cache module: ', module)
    end
    return cache_module[appname] and cache_module[appname][module]
end

local function _set_cache(self, name, val)
    local appname = self.appname
    local cache_module = _G.cache_module
    if not cache_module[appname] then
        cache_module[appname] = {}
    end
    cache_module[appname][name] = val
end

local function _load_module(self, name)
    local cache = _get_cache(self, name)
    if cache == nil then
        local module = false
        local filename = concat({ self.apppath, name, ".lua" })
        if file.exists(filename) then
            module = setmetatable({}, { __index = _G })
            assert(pcall(setfenv(assert(loadfile(filename)), module)))
            setmetatable(module, nil)
        end
        _set_cache(self, name, module)
        return module
    end
    return cache
end

function controller(self, contro)
    local module = "controller/" .. contro
    return _load_module(self, module)
end

function model(self, mod)
    local module = "model/" .. mod
    return _load_module(self, module)
end

function config(self, conf)
    local module = "config/" .. conf
    return _load_module(self, module)
end

setmetatable(_M, class_mt)

