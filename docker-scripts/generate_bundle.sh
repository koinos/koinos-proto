#!/bin/sh

set -e
set -x

OUTDIR=/koinos-proto-build/out

# C++
mkdir -p "$OUTDIR/koinos-proto-cpp/libraries/proto/generated/"
rsync -rvm --include "*.pb.h" --include "*.pb.cc" --include "*/" --exclude "*" /koinos-proto-build/cpp/ "$OUTDIR/koinos-proto-cpp/libraries/proto/generated/"

# golang
mkdir -p "$OUTDIR/koinos-proto-golang/"
rsync -rvm --include "*.pb.go" --include "*/" --exclude "*" /koinos-proto-build/go/ "$OUTDIR/koinos-proto-golang/"

# js/ts
mkdir -p "$OUTDIR/koinos-proto-js/"
rsync -vm --include "index.js" --include "index.d.ts" --include="index.json" --exclude "*" /koinos-proto-build/js/ "$OUTDIR/koinos-proto-js/"

# python
mkdir -p "$OUTDIR/koinos-proto-python/"
rsync -rvm --include "*_pb2.py" --include "*/" --exclude "*" /koinos-proto-build/python/ "$OUTDIR/koinos-proto-python/"

# embedded-cpp
mkdir -p "$OUTDIR/koinos-proto-embedded-cpp/libraries/proto_embedded/generated/"
rsync -rvm --include "*.h" --include "*/" --exclude "*" /koinos-proto-build/eams/ "$OUTDIR/koinos-proto-embedded-cpp/libraries/proto_embedded/generated/"
mkdir -p "$OUTDIR/koinos-proto-embedded-cpp/libraries/proto_embedded/src/"
rsync -rvm --include "*.h" --include "*.cpp" --include "*/" --exclude "*" /koinos-proto-build/EmbeddedProto/src/ "$OUTDIR/koinos-proto-embedded-cpp/libraries/proto_embedded/src/"

# docs
mkdir -p "$OUTDIR/koinos-proto-documentation"
rsync -rvm --include "*.md" /koinos-proto-build/docs "$OUTDIR/koinos-proto-documentation"

# descriptors
mkdir -p "$OUTDIR/koinos-proto-descriptors"
cp /koinos-proto-build/koinos_descriptors.pb "$OUTDIR/koinos-proto-descriptors/koinos_descriptors.pb"

# as
mkdir -p "$OUTDIR/koinos-proto-as/assembly/koinos"
rsync -rvm --include "*.ts" --include "*/" --exclude "*" /koinos-proto-build/as/koinos/ "$OUTDIR/koinos-proto-as/assembly/koinos"

(cd /koinos-proto-build/out && tar c * | gzip -c9) > /koinos-proto-generated.tar.gz
