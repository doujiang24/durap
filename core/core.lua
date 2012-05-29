-- Copyright

module("core.core", package.seeall)

-- global variables
local concat = table.concat

local config = require "config"
local mysql = require "core.mysql"

-- set package.path
local function _set_path()
    if config.require_path and #config.require_path > 0 then
        package.path = concat(config.require_path, ";") .. ";" .. package.path
    end
end

local function _load_common_module()
    if config.common_module and #config.common_module > 0 then
        for k, mod in pairs(config.common_module) do
            _G[mod] = require(mod)
            --ngx.say(mod)
        end
    end
    --ngx.say(utils.file.file_exists('index.lua'))
    --ngx.say(utils.array.name)
end

local function _init_mysql()
    mysql.init()
end

function set_app()
    if not _G.DURAP_HOME then
        _G.DURAP_HOME = ngx.var.DURAP_HOME
        mod = "utils.array"
        _G.utils = {}
        _G.utils.array = require(mod)
    ngx.say(utils.array.name)
        _set_path()
        _load_common_module()
    end
    --ngx.say(utils.array.name)
    ngx.say(DURAP_HOME)
    _init_mysql()
end
