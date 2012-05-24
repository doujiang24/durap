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

function set_app()
    if not _G.DURAP_HOME then
        _G.DURAP_HOME = ngx.var.DURAP_HOME
        _set_path()
    end
    _init_mysql()
end

function _init_mysql()
    mysql.init()
end
