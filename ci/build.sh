#!/bin/bash

set -e
set -x

mkdir -p build/cpp build/go build/js build/eams

protobuf/bin/protoc --experimental_allow_proto3_optional \
   --cpp_out=build/cpp/ \
   --go_out=build/go/ \
   --js_out=library=koinos_proto,one_output_file_per_input_file,binary:build/js \
   `find koinos -name '*.proto'`

pushd EmbeddedProto

../protobuf/bin/protoc --experimental_allow_proto3_optional \
   --plugin=protoc-gen-eams \
   --eams_out=../build/eams \
   -I.. \
   `find ../koinos -name '*.proto'`

popd
