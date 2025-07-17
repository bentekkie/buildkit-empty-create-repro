#!/bin/bash

rm -rf cache fromcache.tar fromcache fromreg.tar fromreg || true
mkdir cache

gcrane pull --format=oci gcr.io/distroless/base-debian12@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26 cache

buildctl --addr=docker-container://buildx_buildkit_gracious_bartik0 build \
    --frontend=dockerfile.v0 \
    --local=dockerfile=. \
    --local=context=. \
    --oci-layout=cache=`pwd`/cache \
    --output=type=oci,dest=fromcache.tar \
    --opt=context:gcr.io/distroless/base-debian12@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26=oci-layout://cache@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26 \

mkdir fromcache
tar -xf fromcache.tar -C fromcache


buildctl --addr=docker-container://buildx_buildkit_gracious_bartik0 build \
    --frontend=dockerfile.v0 \
    --local=dockerfile=. \
    --local=context=. \
    --output=type=oci,dest=fromreg.tar \

mkdir fromreg
tar -xf fromreg.tar -C fromreg
