-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local cjson = require "cjson"
local corehelper = require "helper.core"
local cookielib = require "library.cookie"
local aes = require "resty.aes"

local setmetatable = setmetatable
local error = error
local tonumber = tonumber
local log_error = corehelper.log_error
local get_instance = get_instance
local ngx_var = ngx.var
local time = ngx.time

local json_encode = cjson.encode
local json_decode = cjson.decode
local set_cookie = cookielib.set
local get_cookie = cookielib.get
local set_encode_base64 = ndk.set_var.set_encode_base64
local set_decode_base64 = ndk.set_var.set_decode_base64


module(...)


_VERSION = '0.01'

local def_sess_secure_key = "abcdefghigklmnopqrstuvwxyz123456"
local def_sess_secure_iv = "abcefghigklmnopq"
local def_sess_cookie_key = "__luasess__"
local def_sess_expire_time = "86400"

local mt = { __index = _M }


local function _get_session(self)
    local sess = {}

    local str = get_cookie(self.sess_cookie_key)
    if str then
        local aes256 = self.aes256
        sess = json_decode(aes256:decrypt(set_decode_base64(str)))

        if not sess or type(sess) ~= "table" then
            log_error('failed to decode session, session_str:', str)
            sess = {}
        elseif not sess.__expire_time or tonumber(sess.__expire_time) < time() then
            sess = {}
        end
    end
    self.session_vars = sess
    return sess
end

function init(self)
    local conf = get_instance().loader:config('core')
    local sess_secure_key = conf.sess_secure_key or def_sess_secure_key
    local sess_secure_iv = conf.sess_secure_iv or def_sess_secure_iv
    local sess_cookie_key = conf.sess_cookie_key or def_sess_cookie_key
    local sess_expire_time = conf.sess_expire_time or def_sess_expire_time

    local aes256 = aes:new(sess_secure_key, nil, aes.cipher(256, "cbc"), {iv = sess_secure_iv})
    return setmetatable({
        aes256 = aes256,
        sess_cookie_key = sess_cookie_key,
        expire_time = sess_expire_time,
        session_vars = nil
    }, mt)
end

function get(self, key)
    local ses = self.session_vars or _get_session(self)
    if key then
        return ses[key]
    end
    return ses
end

function set(self, key, value)
    local sess = get(self)

    sess[key] = value
    sess.__expire_time = time() + self.expire_time

    local aes256 = self.aes256
    local str = set_encode_base64(aes256:encrypt(json_encode(sess)))

    set_cookie(self, self.sess_cookie_key, str, nil, '/', ngx_var.host)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

