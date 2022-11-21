#!/bin/sh

set -e
set -x

mkdir -p /koinos-proto-build
cd /koinos-proto-build

go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v1.5.0

git clone --recursive https://github.com/koinos/EmbeddedProto /koinos-proto-build/EmbeddedProto

cd /koinos-proto-build/EmbeddedProto
git checkout $PB_EMBEDDED_CPP_VERSION
sh ./setup.sh

mkdir -p /koinos-proto-build/js
cd /koinos-proto-build/js
yarn add protobufjs@^6.11.3
yarn add @koinos/as-proto-gen@$AS_PROTO_VERSION
yarn global add @jsdevtools/version-bump-prompt
