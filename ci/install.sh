#!/bin/bash

set -e

curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sh
source ~/.nvm/nvm.sh
nvm install $NODE_VERSION
nvm use $NODE_VERSION

node --version

yarn add --dev protobufjs@^6.11.3
yarn add --dev @koinos/as-proto-gen@$AS_PROTO_VERSION
yarn global add @jsdevtools/version-bump-prompt
