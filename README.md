[hub]: https://hub.docker.com/r/loxoo/jellyseerr
[git]: https://github.com/triptixx/jellyseerr/tree/main
[actions]: https://github.com/triptixx/jellyseerr/actions/workflows/main.yml

# [loxoo/jellyseerr][hub]
[![Git Commit](https://img.shields.io/github/last-commit/triptixx/jellyseerr/main)][git]
[![Build Status](https://github.com/triptixx/jellyseerr/actions/workflows/main.yml/badge.svg?branch=main)][actions]
[![Latest Version](https://img.shields.io/docker/v/loxoo/jellyseerr/latest)][hub]
[![Size](https://img.shields.io/docker/image-size/loxoo/jellyseerr/latest)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/loxoo/jellyseerr.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/loxoo/jellyseerr.svg)][hub]

## Usage

```shell
docker run -d \
    --name=srvjellyseerr \
    --restart=unless-stopped \
    --hostname=srvjellyseerr \
    -p 5055:5055 \
    -v $PWD/config:/config \
    loxoo/overseerr
```

## Environment

- `$SUID`         - User ID to run as. _default: `953`_
- `$SGID`         - Group ID to run as. _default: `953`_
- `$TZ`           - Timezone. _optional_

## Volume

- `/config`       - Server configuration file location.

## Network

- `5055/tcp`      - WebUI.
