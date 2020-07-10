provider "vsphere" {
  user                 = var.vsphere_connection.user
  password             = var.vsphere_connection.password
  vsphere_server       = var.vsphere_connection.server
  allow_unverified_ssl = var.vsphere_connection.allow_unverified_ssl
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_build.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_build.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_build.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.kube_network.portgroup
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.virtual_machine_template.name
  datacenter_id = data.vsphere_datacenter.dc.id
}
