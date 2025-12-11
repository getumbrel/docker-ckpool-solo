ARG VERSION=590fb2a2c6164beb85d458b3a212723507a9d8ac

# Build stage
FROM debian:trixie-slim AS builder

ARG VERSION

WORKDIR /build

# Install deps
RUN apt-get update
RUN apt-get install --yes git build-essential yasm autoconf automake libtool libzmq3-dev pkgconf

# Clone and checkout a specific commit
RUN git clone https://bitbucket.org/ckolivas/ckpool-solo.git .
RUN git checkout $VERSION

# Build
RUN ./autogen.sh
RUN ./configure
RUN make

# Final image
FROM debian:trixie-slim

# Install zmq runtime dep
RUN apt-get update
RUN apt-get install --yes libzmq3-dev

# Copy the built binary from the build stage
COPY --from=builder /build/src/ckpool /bin/ckpool

# Stratum
EXPOSE 3333

ENTRYPOINT ["ckpool"]
