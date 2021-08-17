#!/bin/bash

set -e
set -x

#source ~/.gimme/envs/go$GO_VERSION.env
#
#GOPATH=`go env GOPATH`
#PATH=$PATH:$GOPATH

mkdir -p build/cpp build/go

for proto in $(find koinos -name '*.proto'); do
   protobuf/bin/protoc --experimental_allow_proto3_optional --cpp_out=build/cpp/ --go_out=build/go/ $proto
done
