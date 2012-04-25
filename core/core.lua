-- Copyright

module("core.core", package.seeall)

-- global variables
local concat = table.concat

local config = require "config"

-- set package.path
local function _set_path()
    if config.require_path then
        package.path = concat(config.require_path, ";") .. ";" .. package.path
    end
end

function set_app()
    _set_path()
end
