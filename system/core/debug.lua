-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local strhelper = require "helper.string"
local cjson = require "cjson"

local traceback = debug.traceback
local setmetatable = setmetatable
local error = error
local concat = table.concat
local io_open = io.open
local unpack = unpack
local time = ngx.localtime
local type = type
local get_instance = get_instance

local ngx_log = ngx.log
local ngx_err = ngx.ERR


local _M = { _VERSION = '0.01' }


_M.DEBUG = 1
_M.INFO = 2
_M.NOTICE = 3
_M.WARN = 4
_M.ERR = 5

local level_str = {
    'DEBUG',
    'INFO',
    'NOTICE',
    'WARN',
    'ERR'
}

local mt = { __index = _M }

function _M.init(self)
    local dp = get_instance()
    local loader, apppath = dp.loader, dp.APPPATH
    local conf = loader:config('core')
    local debug_level = conf and conf.debug or 'DEBUG'
    local log_level = self[debug_level]

    return setmetatable({
        log_level = log_level,
        log_file = apppath .. "logs/error.log"
    }, mt)
end

local function _log(self, log)
    local file = self.log_file

    local fp, err = io_open(file, "a")
    if not fp then
        ngx_log(ngx_err, "failed to open file: ", file, "; error: ", err)
        return
    end

    local ok, err = fp:write(log, "\n")
    if not ok then
        ngx_log(ngx_err, "failed to write log file, log: ", log)
        return
    end

    fp:close()
end

function _M.log(self, log_level, ...)
    local level = self.log_level
    if log_level < level then
        return
    end

    local args = { ... }
    for i = 1, #args do
        if args[i] == nil then
            args[i] = "nil"
        elseif type(args[i]) == "table" then
            args[i] = "is a table"
        end
    end

    local request = get_instance().request
    local log_vars = {
        time(),
        "host: " .. request.host,
        "request: " .. request.request_uri,
        concat(args, ", "),
        traceback(),
        "\n"
    }

    return _log(self, concat(log_vars, ", "))
end

function _M.vtype(self, val)
    return _M.log(self, _M.DEBUG, "vtype:", type(val))
end

function _M.json(self, val)
    return _M.log(self, _M.DEBUG, "json:", cjson.encode(val))
end

return _M
