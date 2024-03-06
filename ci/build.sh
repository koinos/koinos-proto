#!/bin/bash

set -e
set -x

protobuf/bin/protoc --experimental_allow_proto3_optional --descriptor_set_out=build/koinos_descriptors.pb \
   `find koinos -name '*.proto'` `find google -name '*.proto'` `find openapiv3 -name '*.proto'`

#protobuf/bin/protoc --experimental_allow_proto3_optional --doc_out=build/docs --doc_opt=markdown,api.md `find koinos -name '*rpc*.proto'`

yarn pbjs  --keep-case --target static-module -o build/js/index.js `find ./koinos -name '*.proto'` `find ./google -name '*.proto'`
yarn pbts -o build/js/index.d.ts build/js/index.js
yarn pbjs  --keep-case --target json -o build/js/index.json `find ./koinos -name '*.proto'` `find ./google -name '*.proto'`
