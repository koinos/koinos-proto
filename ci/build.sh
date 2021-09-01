#!/bin/bash

set -e
set -x

mkdir -p build/cpp build/go build/js

protobuf/bin/protoc --experimental_allow_proto3_optional \
       --cpp_out=build/cpp/ \
       --go_out=build/go/ \
       --js_out=library=koinos_proto,one_output_file_per_input_file,binary:build/js \
       `find koinos -name '*.proto'`
