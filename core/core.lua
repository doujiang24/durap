-- Copyright

module("core.core", package.seeall)

-- global variables
local concat = table.concat

---[==[
mysql = require "core.mysql"

foo = "fooname"

-- set package.path
local function _set_path()
    if config.require_path and #config.require_path > 0 then
        package.path = concat(config.require_path, ";") .. ";" .. package.path
    end
end

local function _load_common_utils()
    _G["utils"] = {}
    if config.common_utils and #config.common_utils > 0 then
        for k, mod in pairs(config.common_utils) do
            _G["utils"][mod] = require("utils." .. mod)
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
        _G.config = require "config"
        _G.DURAP_HOME = ngx.var.DURAP_HOME
        _set_path()
        _load_common_utils()
    end
    --ngx.say(utils.array.name)
    --ngx.say(DURAP_HOME)
    _init_mysql()
end

--]==]
