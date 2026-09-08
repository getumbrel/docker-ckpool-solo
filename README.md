# docker-ckpool-solo

> Hardened, multi-architecture ckpool solo-mining image with broad CPU portability.

The image supports Linux amd64 and arm64. Host-specific instruction-set
optimizations are disabled so a build produced on one machine does not crash on
an older CPU. The runtime contains only ckpool and its ZeroMQ runtime
dependencies, and runs as UID/GID `1000:1000` by default.

The upstream ckpool source revision and Debian base image are pinned to make
build inputs auditable. Release tags are immutable and published with SBOM and
provenance attestations.

## Usage

```console
$ docker run --rm ghcr.io/getumbrel/docker-ckpool-solo:v1.2.0-1 --help
-B | --btcsolo
-c CONFIG | --config CONFIG
-D | --daemonise
-g GROUP | --group GROUP
-H | --handover
-h | --help
-k | --killold
-L | --log-shares
-l LOGLEVEL | --loglevel LOGLEVEL
-n NAME | --name NAME
-N | --node
-P | --passthrough
-p | --proxy
-q | --quiet
-R | --redirector
-s SOCKDIR | --sockdir SOCKDIR
-t | --trusted
-u | --userproxy
```

```console
$ docker run --rm --volume "$PWD:/data:ro" -p 3333:3333 ghcr.io/getumbrel/docker-ckpool-solo:v1.2.0-1 --btcsolo --config /data/ckpool.conf
[2025-12-11 17:40:54.742] ckpool generator starting
[2025-12-11 17:40:54.743] ckpool stratifier starting
[2025-12-11 17:40:54.745] ckpool connector starting
[2025-12-11 17:40:54.746] ckpool connector ready
[2025-12-11 17:40:54.760] ckpool generator ready
[2025-12-11 17:40:54.760] Connected to bitcoind: 10.21.21.8:8332
[2025-12-11 17:40:54.772] ckpool stratifier ready
[2025-12-11 17:40:54.779] Mining solo to any incoming valid BTC address username
[2025-12-11 17:40:54.779] Network diff set to 1.0
```

The configuration must point `logdir` at a location writable by UID 1000. The
default working directory, `/app`, contains a writable `logs` directory for
standalone use.

## Building

Build the native architecture locally with:

```console
docker build --tag docker-ckpool-solo:local .
docker run --rm docker-ckpool-solo:local --help
```

The pinned Debian digest and `CKPOOL_COMMIT` build argument should only be
updated together with a reviewed dependency or upstream release change.
Release tags use `<ckpool-version>-<packaging-revision>`, such as `v1.2.0-1`,
so a packaging update never overwrites an existing image.

## Licenses

The Docker packaging in this repository is MIT licensed © Umbrel, Inc.
The bundled ckpool program is licensed under GPL-3.0-or-later by Con Kolivas;
its corresponding source is the pinned upstream revision documented in the
Dockerfile, and its license text is included in the image.
