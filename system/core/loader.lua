-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local filehelper = require "helper.file"
local ltp = require "library.ltp.template"

local setmetatable = setmetatable
local getmetatable = getmetatable
local rawget = rawget
local error = error
local pcall = pcall
local assert = assert
local loadfile = loadfile
local type = type
local setfenv = setfenv
local concat = table.concat
local get_instance = get_instance
local fexists = filehelper.exists
local fread_all = filehelper.read_all
local ltp_load_template = ltp.load_template
local ltp_execute_template = ltp.execute_template

local say = ngx.say
local exit = ngx.exit

local _G = _G


module(...)

_VERSION = '0.01'


local mt = { __index = _M }

local cache_module = {}


function new(self, appname, apppath)
    local res = {
        appname = appname,
        apppath = apppath
    }
    return setmetatable(res, mt)
end

local function _get_cache(self, module)
    local appname = self.appname
    return cache_module[appname] and cache_module[appname][module]
end

local function _set_cache(self, name, val)
    local appname = self.appname
    if not cache_module[appname] then
        cache_module[appname] = {}
    end
    cache_module[appname][name] = val
end

local function _load_module(self, name, force)
    local cache = _get_cache(self, name)
    if force or cache == nil then
        local module = false
        local filename = concat({ self.apppath, name, ".lua" })
        if fexists(filename) then
            module = setmetatable({}, { __index = _G })
            assert(pcall(setfenv(assert(loadfile(filename)), module)))
        end
        _set_cache(self, name, module)
        return module
    end
    return cache
end

function core(self, cr, force)
    local module = "core/" .. cr
    return _load_module(self, module, force)
end

function controller(self, contro, force)
    local module = "controller/" .. contro
    return _load_module(self, module, force)
end

function model(self, mod, force)
    local module = "model/" .. mod
    local m = _load_module(self, module, force)
    return m and type(m.new) == "function" and m:new() or m
end

function config(self, conf, force)
    local module = "config/" .. conf
    return _load_module(self, module, force)
end

function library(self, conf, force)
    local module = "library/" .. conf
    return _load_module(self, module, force)
end

function _ltp_function(self, tpl, force)
    local cache = _get_cache(self, tpl)
    if force or cache == nil then
        local tplfun = false
        local filename = concat({ self.apppath, tpl, ".tpl" })
        if fexists(filename) then
            local fdata = fread_all(filename)
            tplfun = ltp_load_template(fdata, '<?lua','?>')
        else
            local debug = get_instance().debug
            debug:log(debug.ERR, "failed to load tpl:", filename)
            say("failed to load tpl:", tpl)
            exit(200)
        end
        _set_cache(self, tpl, tplfun)
        return tplfun
    end
    return cache
end

function view(self, tpl, data, force)
    local template, data = "views/" .. tpl, data or {}
    local tplfun = _ltp_function(self, template, force)
    local output = {}
    setmetatable(data, { __index = _G })
    ltp_execute_template(tplfun, data, output)
    return output
end

setmetatable(_M, class_mt)

