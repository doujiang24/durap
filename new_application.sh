#!/bin/sh

app=$1


if [ -n "$app" ]; then
    echo "create app: $app"
else
    exit "not app mentioned"
fi


#git clone https://github.com/doujiang24/durap-system.git system
git submodule update --init system


git checkout -b local

rm blog demo README.markdown -rf


mkdir -p $app/controller
mkdir -p $app/config
mkdir -p $app/core
mkdir -p $app/library
mkdir -p $app/logs
mkdir -p $app/model

cp system/lua-releng $app/

touch $app/logs/error.log
chmod a+w $app/logs/error.log

