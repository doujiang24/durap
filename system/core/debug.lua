-- Copyright (C) 2013 doujiang24, MaMa Inc.

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
local maxn = table.maxn

local ngx_var = ngx.var
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
    for i = 1, maxn(args) do
        local typ = type(args[i])
        if typ == "table" then
            local ok, json_str = pcall(cjson.encode, args[i])
            json_str = ok and json_str or "[ERROR can not json encode table]"
            args[i] = "[TABLE]:" .. json_str

        elseif typ == "nil" then
            args[i] = "[NIL]"

        elseif typ == "boolean" then
            args[i] = args[i] and "[BOOLEAN]:true" or "[BOOLEAN]:false"

        elseif typ == "number" then
            args[i] = "[NUMBER]:" .. args[i]

        elseif typ ~= "string" then
            args[i] = "[" .. typ .. " VALUE]"
        end
    end

    local log_vars = {
        time(),
        concat(args, ", "),
        traceback(),
        "host: " .. ngx_var.host,
        "request: " .. ngx_var.request_uri,
        "args: " .. (ngx_var.args or '(empty)'),
        "request_body: " .. (ngx_var.request_body or '(empty)'),
        "\n",
    }

    return _log(self, concat(log_vars, ", "))
end

return _M
