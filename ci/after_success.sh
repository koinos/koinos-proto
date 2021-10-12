#!/bin/bash

COMMIT_HASH=`git rev-parse --short HEAD`

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
   cd ~

   git config --global user.email ${GITHUB_USER_EMAIL}
   git config --global user.name  ${GITHUB_USER_NAME}


   #C++
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-cpp.git

   pushd koinos-proto-cpp

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   mkdir -p libraries/proto/generated
   rsync -rvm --include "*.pb.h" --include "*.pb.cc" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/cpp/ ./libraries/proto/generated/

   git add .

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-cpp.git $TRAVIS_BRANCH
   fi

   popd


   #golang
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-golang.git

   pushd koinos-proto-golang

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   find $TRAVIS_BUILD_DIR/build/go/

   mkdir -p koinos
   rsync -rvm --include "*.pb.go" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/go/github.com/koinos/koinos-proto-golang/ ./

   git add .

   if ! git diff --cached --quiet --exit-code; then
      go mod tidy
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-golang.git $TRAVIS_BRANCH
   fi

   popd


   #js
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-js.git

   pushd koinos-proto-js

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   mkdir -p koinos

   rsync -rvm --include "*.js" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/js/ ./

   git add .

   if [ "$TRAVIS_BRANCH" == "master" ]; then
      npm version patch -git-tag-version false
   fi

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-js.git $TRAVIS_BRANCH
   fi

   #TODO: Publish

   popd


   #python
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-python.git

   pushd koinos-proto-python

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   mkdir -p koinos

   rsync -rvm --include "*_pb2.py" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/python/ ./

   git add .

   if [ "$TRAVIS_BRANCH" == "master" ]; then
      npm version patch -git-tag-version false
   fi

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-python.git $TRAVIS_BRANCH
   fi

   #TODO: Publish

   popd


   #embedded-cpp
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-embedded-cpp.git

   pushd koinos-proto-embedded-cpp

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   mkdir -p libraries/koinos/generated
   mkdir -p libraries/koinos/src

   rsync -rvm --include "*.h" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/eams/ ./libraries/proto_embedded/generated/
   rsync -rvm --include "*.h" --include "*.cpp" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/EmbeddedProto/src/ ./libraries/proto_embedded/src/

   git add .

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-embedded-cpp.git $TRAVIS_BRANCH
   fi

   popd


   #docs
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-documentation.git

   pushd koinos-proto-documentation

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   rsync --include "*.md" $TRAVIS_BUILD_DIR/build/docs ./

   git add .

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-documentation.git $TRAVIS_BRANCH
   fi

   popd


   #descriptors
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-descriptors.git

   pushd koinos-proto-descriptors

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   cp $TRAVIS_BUILD_DIR/build/koinos_descriptors.pb ./koinos_descriptors.pb

   git add .

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-descriptors.git $TRAVIS_BRANCH
   fi

   popd
fi
