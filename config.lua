-- Copyright

module("config", package.seeall)

local DURAP_HOME = DURAP_HOME

-- require path, eg: resty mysql.
require_path = {
}

-- common module
common_utils = {
    'array',
    'file'
}

-- mysql conf
mysql = {
    host = "127.0.0.1",
    port = 3306,
    database = "ngx_test",
    user = "web",
    password = "123",
    max_packet_size = 1024 * 1024
}
