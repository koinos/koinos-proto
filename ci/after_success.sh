#!/bin/bash

set -e

COMMIT_HASH=`git rev-parse --short HEAD`

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
   cd ~

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
fi
