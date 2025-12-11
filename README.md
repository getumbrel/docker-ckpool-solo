# docker-ckpool-solo

> Multi-arch ckpool-solo Docker image with good portability

Disables all CPU optimisations for wide support accross old and modern amd64 and aarch64 CPUs.

## Usage

```
$ docker run -it ghcr.io/getumbrel/docker-ckpool-solo:590fb2a --help
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

```
$ docker run -it --volume $PWD:/data ghcr.io/getumbrel/docker-ckpool-solo:590fb2a --btcsolo --config /data/ckpool.conf
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

## License

MIT © Umbrel, Inc. https://umbrel.com
