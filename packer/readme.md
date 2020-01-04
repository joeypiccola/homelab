# packer

All things packer.

## requirements

Install packer 1.4.5.

### building locally

Download the following plugins, place them in either [packer's plugin dir](https://www.packer.io/docs/extending/plugins.html#installing-plugins) or in the root of this directory. If linux allow them to execute.

- [packer-builder-vsphere](https://github.com/jetbrains-infra/packer-builder-vsphere)
- [packer-provisioner-windows-update](https://github.com/rgl/packer-provisioner-windows-update)

### building in docker

Build an image via the [`dockerfile`](https://github.com/joeypiccola/homelab/blob/master/packer/docker/dockerfile) in `./docker`.

`docker build -t packer_custom .`

`docker images | grep packer_custom`

## usage

### in docker wherever you have docker

`docker run --rm -v ``pwd``:/data -it packer_custom build -force -var-file variables-global.json -var 'username=joey' -var 'password=*' vsphere-iso-2019s.json`

### in linux or windows

`packer build -force -var-file variables-global.json -var 'username=joey' -var 'password=*' ./vsphere-iso-2019s.json`
