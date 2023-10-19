#!/bin/bash

set -e

eval "$(gimme $GO_VERSION)"
source ~/.gimme/envs/go$GO_VERSION.env

wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip
unzip protoc-${PROTOBUF_VERSION}-linux-x86_64.zip -d protobuf

sudo apt-get update
sudo apt-get install protobuf-compiler-grpc

go get -u github.com/google/gnostic/cmd/protoc-gen-openapi@0.6.9
go get -u google.golang.org/protobuf/cmd/protoc-gen-go@v1.30.0
go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0
go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v1.5.0

git clone --recursive https://github.com/koinos/EmbeddedProto
pushd EmbeddedProto

git checkout $PB_EMBEDDED_CPP_VERSION
./setup.sh

pwd

popd

pwd

curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sh
source ~/.nvm/nvm.sh
nvm install $NODE_VERSION
nvm use $NODE_VERSION

node --version

yarn add --dev protobufjs@^6.11.3
yarn add --dev @koinos/as-proto-gen@$AS_PROTO_VERSION
yarn global add @jsdevtools/version-bump-prompt
