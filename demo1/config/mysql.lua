-- Copyright (C) Dejiang Zhu (doujiang24)

local _M = {
    timeout = 3000,

    host = "127.0.0.1",
    port = "3306",
    database = "ngx_test",
    user = "ngx_test",
    password = "ngx_test",
    max_packet_size = 1024 * 1024,

    max_keepalive = 100,

    charset = "utf8",

}

return _M
