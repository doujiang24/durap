-- Copyright (C) Dejiang Zhu (doujiang24)


local _M = {
    debug = "DEBUG",

    default_ctr = "home",

    sess_secure_key = "abcdefghigklmnopqrstuvwxyz123456",
    sess_secure_iv = "abcefghigklmnopq",
    sess_expire_time = "86400",

    sess_cookie_key = "__luasess__",
}

return _M
