-- Copyright (C) 2013 doujiang24, MaMa Inc.

local cjson = require "cjson"
local corehelper = require "helper.core"
local urlhelper = require "helper.url"
local cookielib = require "core.cookie"
local aes = require "resty.aes"

local setmetatable = setmetatable
local tonumber = tonumber
local type = type
local log_error = corehelper.log_error
local root_domain = urlhelper.root_domain
local get_instance = get_instance
local ngx_var = ngx.var
local time = ngx.time

local json_encode = cjson.encode
local json_decode = cjson.decode
local set_cookie = cookielib.set
local get_cookie = cookielib.get
local set_encode_base64 = ndk.set_var.set_encode_base64
local set_decode_base64 = ndk.set_var.set_decode_base64
local pcall = pcall


local _M = { _VERSION = '0.01' }


local cookie_sess_expire_time = 86400 * 400

local def_sess_secure_key = "abcdefghigklmnopqrstuvwxyz123456"
local def_sess_secure_iv = "abcefghigklmnopq"
local def_sess_cookie_key = "__luasess__"
local def_sess_expire_time = "86400"

local mt = { __index = _M }


local function _get_session(self, str, tolerate_expt)
    local sess, tolerate_expt = {}, tolerate_expt or 0

    local str = str or get_cookie(self.sess_cookie_key)
    if str then
        local aes256 = self.aes256
        local ok, bin = pcall(set_decode_base64, str)
        sess = json_decode(aes256:decrypt(ok and bin or '') or '""')

        if not sess or type(sess) ~= "table" then
            log_error('failed to decode session, session_str:', str)
            sess = {}
        elseif not sess.__expt or tonumber(sess.__expt) + tonumber(tolerate_expt) < time() then
            sess = {}
        end
    end
    self.session_vars = sess
    return sess
end

function _M.init(self, conf)
    local conf = conf or get_instance().loader:config('core')
    local sess_secure_key = conf.sess_secure_key or def_sess_secure_key
    local sess_secure_iv = conf.sess_secure_iv or def_sess_secure_iv

    local aes256 = aes:new(sess_secure_key, nil, aes.cipher(256, "cbc"), {iv = sess_secure_iv})
    return setmetatable({
        aes256 = aes256,
        sess_cookie_key = conf.sess_cookie_key or def_sess_cookie_key,
        expire_time = conf.sess_expire_time or def_sess_expire_time,
        domain = conf.sess_domain or root_domain(ngx_var.host),
        session_vars = nil
    }, mt)
end

function _M.get(self, key, str, tolerate_expt)
    local sess = self.session_vars or _get_session(self, str, tolerate_expt)
    if key then
        return sess[key]
    end
    return sess
end

function _M.set(self, key, value)
    local sess = _M.get(self)

    if type(key) == "table" then
        sess = key
    else
        sess[key] = value
    end
    sess.__expt = time() + self.expire_time

    local aes256 = self.aes256
    local str = set_encode_base64(aes256:encrypt(json_encode(sess)))

    set_cookie(self.sess_cookie_key, str, cookie_sess_expire_time, '/', self.domain)
end

function _M.expt(self, expire_time)
    if expire_time then
        self.expire_time = expire_time
        return true
    end
end

function _M.domain(self, domain)
    self.domain = domain
end

return _M
