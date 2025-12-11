# docker-ckpool-solo

> Multiarch ckpool-solo Docker image with good portability

Disables all CPU optimisations for wide support accross old and modern amd64 and aarch64 CPUs.

## Usage

```
docker run -it ghcr.io/getumbrel/docker-ckpool-solo:590fb2a -h
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

## License

MIT © Umbrel, Inc. https://getumbrel.com/
