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
   rsync -rvm --include "*.capnp.c++" --include "*.capnp.h" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/cpp/ ./libraries/proto/generated/

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

   mkdir -p koinos
   rsync -rvm --include "*.capnp.go" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/go/ ./koinos/

   git add .

   if ! git diff --cached --quiet --exit-code; then
      go mod tidy
      git commit -m "Update for koinos-proto commit $COMMIT_HASH"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-golang.git $TRAVIS_BRANCH
   fi

   popd
fi
