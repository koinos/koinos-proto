#!/bin/bash

set -e
set -x

eval "$(gimme $GO_VERSION)"
source ~/.gimme/envs/go$GO_VERSION.env

GO111MODULE=on go get capnproto.org/go/capnp/v3
go get -u capnproto.org/go/capnp/v3/...

curl -O https://capnproto.org/capnproto-c++-0.8.0.tar.gz
tar zxf capnproto-c++-0.8.0.tar.gz
cd capnproto-c++-0.8.0
./configure
make -j3 check
sudo make install
