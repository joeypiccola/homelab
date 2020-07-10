# packer

All things packer.

## requirements

| platform | packer | packer-provisioner-windows-update | vmware-tools    |
|----------|--------|-----------------------------------|-----------------|
| docker   | 1.6.0  | 0.9.0                             | 11.0.5-15389592 |
| windows  |        |                                   | 11.0.5-15389592 |

### credentials

A file named `variables-cred.json` with the following. This should have rights in vCenter.

```json
{
    "username": "-",
    "password": "-"
}
```

### building locally

Download the following plugins, place them in either [packer's plugin dir](https://www.packer.io/docs/extending/plugins.html#installing-plugins) or in the root of this directory. If linux allow them to execute.

- [packer-provisioner-windows-update](https://github.com/rgl/packer-provisioner-windows-update)

### building in docker

Build an image via the [`dockerfile`](https://github.com/joeypiccola/homelab/blob/master/packer/docker/dockerfile) in `./docker`.

`docker build -t packer_custom .`

`docker images | grep packer_custom`

## usage

### in docker wherever you have docker

``docker run -v `pwd`:/data -it packer_custom build -force -var-file variables-global.json -var-file variables-cred.json vsphere-iso-2016s.json``

``docker run -v `pwd`:/data -it packer_custom build -force -var-file variables-global.json -var-file variables-cred.json vsphere-iso-ubuntu18.json``

### in linux or windows

`packer build -force ./vsphere-iso-2019s.json -var-file variables-global.json -var-file variables-cred.json`
