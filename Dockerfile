FROM golang:1.16-alpine AS builder

RUN apk update && \
    apk add \
        curl \
        git \
        nodejs \
        npm \
        protoc \
        python3 \
        rsync \
        yarn

ADD . /koinos-proto
WORKDIR /koinos-proto

ENV PROTOBUF_VERSION="3.17.3"
ENV PB_EMBEDDED_CPP_VERSION="negative-enums"
ENV NODE_VERSION="16.14.2"
ENV AS_PROTO_VERSION="0.4.2"

RUN /koinos-proto/docker-scripts/install.sh
RUN /koinos-proto/docker-scripts/build.sh
RUN /koinos-proto/docker-scripts/generate_bundle.sh