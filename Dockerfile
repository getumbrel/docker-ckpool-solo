# syntax=docker/dockerfile:1

ARG DEBIAN_IMAGE=debian:trixie-slim@sha256:d7e12182ce18b85b93007c1dedf31f2d29e01ccf3182cc4017c709b6259bc132

FROM ${DEBIAN_IMAGE} AS builder

ARG CKPOOL_COMMIT=2e44101e2da2c11f499be76d16e6a26cd95cfea7

WORKDIR /build

RUN apt-get update \
    && apt-get install --no-install-recommends --yes \
        autoconf \
        automake \
        build-essential \
        ca-certificates \
        git \
        libtool \
        libzmq3-dev \
        pkgconf \
        yasm \
    && rm -rf /var/lib/apt/lists/*

# Fetch and verify the immutable upstream revision instead of trusting a
# movable tag.
RUN git init . \
    && git remote add origin https://bitbucket.org/ckolivas/ckpool.git \
    && git fetch --depth 1 origin "${CKPOOL_COMMIT}" \
    && test "$(git rev-parse FETCH_HEAD)" = "${CKPOOL_COMMIT}" \
    && git checkout --detach FETCH_HEAD

# Upstream selects instruction sets from the build host. That is unsafe for a
# portable multi-architecture image, particularly when arm64 is built in QEMU.
RUN sed -i "s/host_cpu = 'x86_64'/host_cpu = 'x86_64-disabled'/" configure.ac \
    && sed -i "s/host_cpu = 'aarch64'/host_cpu = 'aarch64-disabled'/" configure.ac

RUN ./autogen.sh \
    && ./configure CFLAGS="-O2 -Wall" CXXFLAGS="-O2 -Wall" \
    && make -j "$(nproc)" \
    && make check \
    && strip --strip-unneeded /build/src/ckpool

FROM ${DEBIAN_IMAGE} AS runtime

ARG CKPOOL_VERSION=1.2.0
ARG CKPOOL_COMMIT=2e44101e2da2c11f499be76d16e6a26cd95cfea7

LABEL org.opencontainers.image.title="docker-ckpool-solo" \
      org.opencontainers.image.description="Portable multi-architecture ckpool solo-mining server" \
      org.opencontainers.image.licenses="MIT AND GPL-3.0-or-later" \
      org.opencontainers.image.version="${CKPOOL_VERSION}" \
      org.ckpool.upstream.commit="${CKPOOL_COMMIT}" \
      org.ckpool.upstream.source="https://bitbucket.org/ckolivas/ckpool"

RUN apt-get update \
    && apt-get install --no-install-recommends --yes libzmq5 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 ckpool \
    && useradd --uid 1000 --gid ckpool --home-dir /app --shell /usr/sbin/nologin ckpool \
    && install --directory --owner ckpool --group ckpool /app/bin /app/logs

COPY --from=builder --chown=ckpool:ckpool /build/src/ckpool /app/bin/ckpool
COPY --from=builder /build/COPYING /usr/share/doc/ckpool/COPYING

WORKDIR /app
USER 1000:1000

EXPOSE 3333

ENTRYPOINT ["/app/bin/ckpool"]
