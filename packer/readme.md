# packer

All things packer.

## requirments

https://github.com/jetbrains-infra/packer-builder-vsphere
https://github.com/rgl/packer-provisioner-windows-update


```bash
packer --version
1.4.4
```

```bash
chmod 755 packer-builder-vsphere-iso
```

## usage

`packer build -force -var-file variables-global.json -var 'username=joey' -var 'password=*' ./vsphere-iso-2016s.json`
`packer build -force -var-file variables-global.json -var 'username=joey' -var 'password=*' ./vsphere-iso-2019s.json`
