# dynamicdns

All things dynamicdns.

## what

This is a simple PowerShell script that monitors your external IP and updates it at [freedns.afraid.org](https://freedns.afraid.org/) then notifies via [Pushover](https://pushover.net/) of the change.

## how

Simply place `Update-DNS.ps1` in the same directory as `configData.json` and run the script. This of course assumes you've setup \ made accounts on both [freedns.afraid.org](https://freedns.afraid.org/) and [Pushover](https://pushover.net/).

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
