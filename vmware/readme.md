# vmware

All things vmware.

## storage iops fix

See VMware [Adjusting Round Robin IOPS limit from default 1000 to 1 (2069356)](https://kb.vmware.com/s/article/2069356) for details.

```bash
for i in `esxcfg-scsidevs -c | awk '{print $1}' | grep naa.6589cfc000000ec74fdbc3706959b74d`; do esxcli storage nmp psp roundrobin deviceconfig set --type=iops --iops=1 --device=$i; done
```
