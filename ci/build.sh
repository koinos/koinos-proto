#!/bin/bash

set -e
set -x

mkdir -p build/cpp build/go build/js build/python build/eams build/docs build/as

protobuf/bin/protoc --experimental_allow_proto3_optional \
   --cpp_out=build/cpp/ \
   --go_out=build/go/ \
   --python_out=build/python \
   --descriptor_set_out=build/koinos_descriptors.pb \
   --plugin=protoc-gen-as=/home/travis/.yarn/bin/as-proto-gen \
   --as_out=build/as \
   `find koinos -name '*.proto'`

protobuf/bin/protoc --experimental_allow_proto3_optional --doc_out=build/docs --doc_opt=markdown,api.md `find koinos -name '*rpc*.proto'`

pushd EmbeddedProto

../protobuf/bin/protoc --experimental_allow_proto3_optional \
   --plugin=protoc-gen-eams \
   --eams_out=../build/eams \
   -I.. \
   `find ../koinos -name '*.proto'`

popd

yarn pbjs  --keep-case --target static-module -o build/js/index.js `find ./koinos -name '*.proto'` `find ./google -name '*.proto'`
yarn pbts -o build/js/index.d.ts build/js/index.js
yarn pbjs  --keep-case --target json -o build/js/index.json `find ./koinos -name '*.proto'` `find ./google -name '*.proto'`
