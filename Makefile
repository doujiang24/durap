OPENRESTY_PREFIX=/opt/openresty

PREFIX ?=          /usr/local
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR ?=     $(PREFIX)/lib/lua/$(LUA_VERSION)

.PHONY: all test

all: ;

test: all
	PATH=$(OPENRESTY_PREFIX)/nginx/sbin:$$PATH prove -I ../../../git/test-nginx/lib -r t

