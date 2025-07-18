#!/bin/bash

rm -rf cache fromcache.tar fromcache fromreg.tar fromreg || true
mkdir cache

gcrane pull --format=oci gcr.io/distroless/base-debian12@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26 cache

docker buildx build \
    --build-context gcr.io/distroless/base-debian12@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26=oci-layout://`pwd`/cache@sha256:201ef9125ff3f55fda8e0697eff0b3ce9078366503ef066653635a3ac3ed9c26 \
    --output=type=oci,dest=fromcache.tar .

mkdir fromcache
tar -xf fromcache.tar -C fromcache

docker buildx build \
    --output=type=oci,dest=fromreg.tar .

mkdir fromreg
tar -xf fromreg.tar -C fromreg
