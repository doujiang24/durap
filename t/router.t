# vim:set ft= ts=4 sw=4 et:

my @skip;
BEGIN {
    if ($ENV{LD_PRELOAD} =~ /\bmockeagain\.so\b/) {
        @skip = (skip_all => 'too slow in mockeagain mode')
    }
}

use Test::Nginx::Socket @skip;
use Cwd qw(cwd);

repeat_each(5);
#repeat_each(10);

plan tests => repeat_each() * (3 * blocks());

my $pwd = cwd();

our $HttpConfig = qq{
    resolver \$TEST_NGINX_RESOLVER;
    lua_package_path "$pwd/system/?.lua;;";
};

$ENV{TEST_NGINX_RESOLVER} = '8.8.8.8';
$ENV{TEST_NGINX_MYSQL_PORT} ||= 3306;
$ENV{TEST_NGINX_MYSQL_HOST} ||= '127.0.0.1';
$ENV{TEST_NGINX_MYSQL_PATH} ||= '/var/run/mysql/mysql.sock';
$ENV{TEST_NGINX_ROOT_PATH} ||= "$pwd/";

#log_level 'warn';

#no_long_string();
#no_diff();
no_shuffle();

run_tests();

__DATA__

=== TEST 1: test router
--- http_config eval: $::HttpConfig
--- config
    location /t {
        set $router_uri "/welcome/hello/dou";
        set $APPNAME "demo1";
        set $ROOT $TEST_NGINX_ROOT_PATH;

        content_by_lua '
            local debug = require "core.debug"
            local durap = require "core.durap"

            local dp = durap:init(debug.DEBUG)

            debug = dp.debug

            local router = require "core.router"
            local rt = router:new()

            local ctr, func, args = rt:route()

            if not ctr then
                ngx.exit(404)
            end

            ctr[func](unpack(args));
        ';
    }
--- request
GET /t
--- response_body eval
'say hello, dou.' . "\n"
--- no_error_log
[error]


=== TEST 2: test mysql
--- http_config eval: $::HttpConfig
--- config
    location /t {
        set $router_uri "/welcome/database";
        set $APPNAME "demo1";
        set $ROOT $TEST_NGINX_ROOT_PATH;

        content_by_lua '
            local debug = require "core.debug"
            local durap = require "core.durap"

            local dp = durap:init(debug.DEBUG)

            debug = dp.debug

            local router = require "core.router"
            local rt = router:new()

            local ctr, func, args = rt:route()

            if not ctr then
                ngx.exit(404)
            end

            ctr[func](unpack(args));
        ';
    }
--- request
GET /t
--- response_body eval
'table welcome created.
new one added.
count num match list count.' . "\n"
--- no_error_log
[error]


=== TEST 3: test mysql
--- http_config eval: $::HttpConfig
--- config
    location /t {
        set $router_uri "/welcome/redis/dou";
        set $APPNAME "demo1";
        set $ROOT $TEST_NGINX_ROOT_PATH;

        content_by_lua '
            local debug = require "core.debug"
            local durap = require "core.durap"

            local dp = durap:init(debug.DEBUG)

            debug = dp.debug

            local router = require "core.router"
            local rt = router:new()

            local ctr, func, args = rt:route()

            if not ctr then
                ngx.exit(404)
            end

            ctr[func](unpack(args));
        ';
    }
--- request
GET /t
--- response_body eval
'add success
get success
get match the add' . "\n"
--- no_error_log
[error]


