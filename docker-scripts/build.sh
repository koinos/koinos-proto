#!/bin/sh

set -e
set -x

mkdir -p \
   /koinos-proto-build/cpp \
   /koinos-proto-build/go \
   /koinos-proto-build/js \
   /koinos-proto-build/python \
   /koinos-proto-build/eams \
   /koinos-proto-build/docs \
   /koinos-proto-build/as

KOINOS_PROTOS=$(find /koinos-proto/koinos -name "*.proto")
GOOGLE_PROTOS=$(find /koinos-proto/google -name "*.proto")
RPC_PROTOS=$(find /koinos-proto/koinos -name "*rpc*.proto")

protoc --experimental_allow_proto3_optional \
   -I/koinos-proto \
   --cpp_out=/koinos-proto-build/cpp/ \
   --go_out=/koinos-proto-build/go/ \
   --python_out=/koinos-proto-build/python \
   --descriptor_set_out=/koinos-proto-build/koinos_descriptors.pb \
   --plugin=protoc-gen-as=/koinos-proto-build/js/node_modules/.bin/as-proto-gen \
   --as_out=/koinos-proto-build/as \
   $KOINOS_PROTOS

protoc --experimental_allow_proto3_optional \
   -I/koinos-proto \
   --doc_out=/koinos-proto-build/docs --doc_opt=markdown,api.md \
   $RPC_PROTOS

protoc --experimental_allow_proto3_optional \
   -I/koinos-proto \
   --plugin=/koinos-proto/docker-scripts/protoc-gen-eams \
   --eams_out=/koinos-proto-build/eams \
   $KOINOS_PROTOS

cd /koinos-proto-build/js

yarn pbjs  --keep-case --target static-module -o /koinos-proto-build/js/index.js $KOINOS_PROTOS $GOOGLE_PROTOS
yarn pbts -o /koinos-proto-build/js/index.d.ts /koinos-proto-build/js/index.js
yarn pbjs  --keep-case --target json -o /koinos-proto-build/js/index.json $KOINOS_PROTOS $GOOGLE_PROTOS
