# vsphere connection vars
variable "vsphere_connection" {
  type    = map
  default = {
    allow_unverified_ssl = false
    password             = ""
    server               = ""
    user                 = ""
  }
}

# vsphere source template clone vars
variable "virtual_machine_template" {
  type    = map
  default = {
    name                = ""
    connection_type     = "ssh"
    connection_user     = "vagrant"
    connection_password = "vagrant"
  }
}

variable "vsphere_build" {
  type    = map
  default = {
    cluster    = ""
    datacenter = ""
    datastore  = ""
    folder     = ""
  }
}

variable "kube_nodes" {
  type = map
  default = {
    cpus             = 2
    memory           = 2048
    node_name_prefix = "kube-node"
  }
}

variable "kube_masters" {
  type = map
  default = {
    cpus             = 2
    memory           = 4096
    node_name_prefix = "kube-master"
  }
}

variable "kube_config" {
  type = map
  default = {
    admin_user   = "kube_admin"
    master_count = 1
    node_count   = 3
  }
}

variable "kube_network" {
  type    = map
  default = {
    dns_servers               = ""
    domain                    = ""
    ipv4_master_gateway       = ""
    ipv4_master_netmask       = ""
    ipv4_master_network       = ""
    ipv4_master_start_address = ""
    ipv4_node_gateway         = ""
    ipv4_node_netmask         = ""
    ipv4_node_network         = ""
    ipv4_node_start_address   = ""
    portgroup                 = ""
  }
}
