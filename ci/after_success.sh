#!/bin/bash

COMMIT_HASH=`git rev-parse --short HEAD`

cd ~

git config --global user.email ${GITHUB_USER_EMAIL}
git config --global user.name  ${GITHUB_USER_NAME}


#C++
git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-cpp.git

pushd koinos-proto-cpp

mkdir -p libraries/proto/include/koinos/proto
find $TRAVIS_BUILD_DIR/build/cpp
rsync -rvm --include "*.c++" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/cpp/ ./libraries/proto/
rsync -rvm --include "*.h" --include "*/" --exclude "*" $TRAVIS_BUILD_DIR/build/cpp/ ./libraries/proto/include/koinos/proto/

git add .

if ! git diff --cached --quiet --exit-code; then
   git commit -m "Update for koinos-proto commit $COMMIT_HASH"
   git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-cpp.git
fi

popd


#golang
git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-golang.git

pushd koinos-proto-golang

mkdir -p koinos
find $TRAVIS_BUILD_DIR/build/go
rsync -rvm $TRAVIS_BUILD_DIR/build/go/ ./koinos/

git add .

if ! git diff --cached --quiet --exit-code; then
   git commit -m "Update for koinos-proto commit $COMMIT_HASH"
   git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-golang.git
fi

popd
