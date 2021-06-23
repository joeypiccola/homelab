# dynamicdns

All things dynamicdns.

## what

This is a simple PowerShell script that monitors your external IP and updates it at [freedns.afraid.org](https://freedns.afraid.org/) then notifies via [Pushover](https://pushover.net/) of the change.

## how

Simply place `./scripts/Update-DNS.ps1` in the same directory as `./scripts/configData.json` and run the script. This of course assumes you've setup \ made accounts on both [freedns.afraid.org](https://freedns.afraid.org/) and [Pushover](https://pushover.net/).

### configData

The following `configData.json` will need to be updated with secrets.

```json
{
    "pushoverToken": "<SECRET>",
    "pushoverUser": "<SECRET>",
    "lastIP": "-",
    "icanhazipUri": "http://icanhazip.com",
    "pushoverUri": "https://api.pushover.net/1/messages.json",
    "freednsUri": "https://freedns.afraid.org/dynamic/update.php?<SECRET>"
}
```

## run it in docker

Credit to [xordiv](https://github.com/xordiv) for [docker-alpine-cron](https://github.com/xordiv/docker-alpine-cron) (e.g. `docker-cmd.sh` and `docker-entry.sh`).

1. build the image

`docker build -t dynamicdns .`
`docker build -t "dyndns_pwsh:7.1.3" -t "dyndns_pwsh:latest" .`

2. maybe get it up on the hub, get this in CI!

```
docker build -t "username/dyndns_pwsh:7.1.3" -t "username/dyndns_pwsh:latest" .
cat ./docker_hub_pwd | docker login --username username --password-stdin
docker push username/dyndns_pwsh:latest
docker push username/dyndns_pwsh:7.1.3
```

3. use `docker-compose` to start it

`docker-compose up -d`
