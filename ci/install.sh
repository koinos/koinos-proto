#!/bin/bash

eval "$(gimme $GO_VERSION)"
source ~/.gimme/envs/go$GO_VERSION.env

wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip
unzip protoc-${PROTOBUF_VERSION}-linux-x86_64.zip -d protobuf

go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
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
nvm usm $NODE_VERSION

node --version

npm install -g lerna

git clone --recursive https://github.com/koinos/as-proto.git
pushd as-proto
git checkout default-value
yarn add @types/node
yarn add rimraf
yarn add typescript
yarn install
yarn build
yarn link
popd

yarn add --dev protobufjs
#yarn add --dev @roaminroe/as-proto-gen@$AS_PROTO_VERSION
#yarn add --dev as-proto-gen@koinos/as-proto#default-value
yarn link "as-proto-workspace"
yarn global add @jsdevtools/version-bump-prompt
