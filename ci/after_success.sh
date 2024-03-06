#!/bin/bash

set -e

COMMIT_HASH=`git rev-parse --short HEAD`

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
   cd ~

   #js/ts
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-js.git

   pushd koinos-proto-js

   cp ${TRAVIS_BUILD_DIR}/build/js/index.js index.js
   cp ${TRAVIS_BUILD_DIR}/build/js/index.d.ts index.d.ts
   cp ${TRAVIS_BUILD_DIR}/build/js/index.json index.json

   git add .

   if ! git diff --cached --quiet --exit-code; then
      if [ "${TRAVIS_BRANCH}" != "master" ]; then
         git checkout -b ${TRAVIS_BRANCH}
      fi

      git add .

      git commit -m "Update for koinos-proto commit ${COMMIT_HASH}"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-js.git ${TRAVIS_BRANCH}
   fi

   if ! [ -z "${TRAVIS_TAG}" ]; then
      npm version ${TRAVIS_TAG} -m "Update version to %s"
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-js.git master
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-js.git ${TRAVIS_TAG}
   fi

   popd


   #python
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-python.git

   pushd koinos-proto-python

   mkdir -p koinos

   rsync -rvm --include "*_pb2.py" --include "*/" --exclude "*" --exclude ".*/" --delete ${TRAVIS_BUILD_DIR}/build/python/ ./

   git add .

   if ! git diff --cached --quiet --exit-code; then
      if [ "${TRAVIS_BRANCH}" != "master" ]; then
         git checkout -b ${TRAVIS_BRANCH}
      fi

      git commit -m "Update for koinos-proto commit ${COMMIT_HASH}"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-python.git ${TRAVIS_BRANCH}
   fi

   if ! [ -z "${TRAVIS_TAG}" ]; then
      git tag -a ${TRAVIS_TAG} -m "proto tag ${TRAVIS_TAG}"
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-python.git ${TRAVIS_TAG}
   fi

   #TODO: Publish

   popd


   #docs
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-documentation.git

   pushd koinos-proto-documentation

   rsync -rvm --include "*.md" ${TRAVIS_BUILD_DIR}/build/docs ./

   git add .

   if ! git diff --cached --quiet --exit-code; then
      if [ "${TRAVIS_BRANCH}" != "master" ]; then
         git checkout -b ${TRAVIS_BRANCH}
      fi

      git commit -m "Update for koinos-proto commit ${COMMIT_HASH}"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-documentation.git ${TRAVIS_BRANCH}
   fi

   if ! [ -z "${TRAVIS_TAG}" ]; then
      git tag -a ${TRAVIS_TAG} -m "proto tag ${TRAVIS_TAG}"
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-documentation.git ${TRAVIS_TAG}
   fi

   popd


   #descriptors
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-descriptors.git

   pushd koinos-proto-descriptors

   cp ${TRAVIS_BUILD_DIR}/build/koinos_descriptors.pb ./koinos_descriptors.pb

   git add .

   if ! git diff --cached --quiet --exit-code; then
      if [ "${TRAVIS_BRANCH}" != "master" ]; then
         git checkout -b ${TRAVIS_BRANCH}
      fi

      git commit -m "Update for koinos-proto commit ${COMMIT_HASH}"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-descriptors.git ${TRAVIS_BRANCH}
   fi

   if ! [ -z "${TRAVIS_TAG}" ]; then
      git tag -a ${TRAVIS_TAG} -m "proto tag ${TRAVIS_TAG}"
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-descriptors.git ${TRAVIS_TAG}
   fi

   popd


   #as
   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-as.git

   pushd koinos-proto-as

   mkdir -p assembly/koinos
   rsync -rvm --include "*.ts" --include "*/" --exclude "*" --exclude ".*/" --delete ${TRAVIS_BUILD_DIR}/build/as/koinos/ ./assembly/koinos

   ./generate_index.sh

   git add .

   if ! git diff --cached --quiet --exit-code; then
      if [ "${TRAVIS_BRANCH}" != "master" ]; then
         git checkout -b ${TRAVIS_BRANCH}
      fi

      git commit -m "Update for koinos-proto commit ${COMMIT_HASH}"
      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-as.git ${TRAVIS_BRANCH}
   fi

   if ! [ -z "${TRAVIS_TAG}" ]; then
      npm version ${TRAVIS_TAG} -m "Update version to %s"
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-as.git master
      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-proto-as.git ${TRAVIS_TAG}
   fi

   popd

   #openapi

#   git clone https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-openapi.git
#
#   pushd koinos-openapi
#
#   cp ${TRAVIS_BUILD_DIR}/build/openapi/* ./
#
#   git add .
#
#   if ! git diff --cached --quiet --exit-code; then
#      if [ "${TRAVIS_BRANCH}" != "master" ]; then
#         git checkout -b ${TRAVIS_BRANCH}
#      fi
#
#      git commit -m "Update for koinos-proto commit ${COMMIT_HASH}"
#      git push --force https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-openapi.git ${TRAVIS_BRANCH}
#   fi
#
#   if ! [ -z "${TRAVIS_TAG}" ]; then
#      npm version ${TRAVIS_TAG} -m "Update version to %s"
#      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-openapi.git master
#      git push https://${GITHUB_USER_TOKEN}@github.com/koinos/koinos-openapi.git ${TRAVIS_TAG}
#   fi
#
#   popd
fi
