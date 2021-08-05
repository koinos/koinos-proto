#!/bin/bash

set -e
set -x

source ~/.gimme/envs/go$GO_VERSION.env

GOPATH=`go env GOPATH`
PATH=$PATH:$GOPATH

mkdir -p build/cpp build/go

for proto in $(find ./schema -name '*.capnp'); do
   capnp compile -I$GOPATH/pkg/mod/capnproto.org/go/capnp/v3@v3.0.0-alpha.1/std --src-prefix=schema/ -oc++:build/cpp -ogo:build/go $proto
done
