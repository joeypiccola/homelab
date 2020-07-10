# terraform k8s

All things Terraform k8s.

## tfvars

The following `terraform.tfvars` is not included in this repo. Still trying to figure out secrets.

```tfvars
vsphere_connection = {
  allow_unverified_ssl = true
  password             = "-"
  server               = "-"
  user                 = "-"
}

virtual_machine_template = {
  name                = "ubuntu18-packer"
  connection_type     = "ssh"
  connection_user     = "vagrant"
  connection_password = "vagrant"
}

vsphere_build = {
  cluster    = "BC1"
  datacenter = "Basement"
  datastore  = "freenas_datastore_1"
  folder     = "ad.piccola.us/production/kubernetes"
}

kube_network = {
  dns_servers               = "10.0.3.24"
  domain                    = "piccola.us"
  ipv4_master_gateway       = "10.0.3.1"
  ipv4_master_netmask       = 24
  ipv4_master_network       = "10.0.3.0"
  ipv4_master_start_address = "161"
  ipv4_node_gateway         = "10.0.3.1"
  ipv4_node_netmask         = 24
  ipv4_node_network         = "10.0.3.0"
  ipv4_node_start_address   = "151"
  portgroup                 = "VLAN3_primary_LAN"
}
```
