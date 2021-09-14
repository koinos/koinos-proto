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


   #embedded-cpp
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-embedded-cpp.git

   pushd koinos-proto-embedded-cpp

   if [ "$TRAVIS_BRANCH" != "master" ]; then
      git checkout -b $TRAVIS_BRANCH
   fi

   mkdir -p libraries/koinos/generated
   mkdir -p libraries/koinos/src

   rsync -rvm --include "*.h" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/eams/ ./libraries/koinos/generated/
   rsync -rvm --include "*.h" --include "*.cpp" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/EmbeddedProto/src/ ./libraries/koinos/src/

   git add .

   if ! git diff --cached --quiet --exit-code; then
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-embedded-cpp.git $TRAVIS_BRANCH
   fi
fi
