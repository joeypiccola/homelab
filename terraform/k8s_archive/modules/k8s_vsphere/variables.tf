variable "vsphere_server" {
  type        = string
  description = ""
}
variable "vsphere_allow_unverified_ssl" {
  type        = bool
  default     = false
  description = ""
}

variable "vsphere_cluster" {
  type        = string
  description = ""
}

variable "vsphere_datacenter" {
  type        = string
  description = ""
}

variable "vsphere_portgroup" {
  type        = string
  description = ""
}

variable "vsphere_datastore" {
  type        = string
  description = ""
}

variable "vsphere_folder" {
  type        = string
  description = ""
}

variable "vsphere_user" {
  type        = string
  description = ""
}

variable "vsphere_password" {
  type        = string
  description = ""
}

variable "vsphere_template" {
  type        = string
  description = ""
}

variable "controlplane_count" {
  type        = number
  description = 3
}

variable "worker_count" {
  type        = number
  description = 2
}

variable "cluster_subnet" {
  type        = string
  description = ""
}

variable "cluster_netmask" {
  type        = string
  description = ""
}

variable "cluster_gateway" {
  type = string
  description = ""
}

variable "cluster_start_address" {
  type        = number
  description = ""
}

variable "dns_servers" {
  type    = list(string)
  description = ""
}

variable "controlplane_name_prefix" {
  type        = string
  description = ""
  default = "node-ctrl-"
}

variable "worker_name_prefix" {
  type        = string
  description = ""
  default = "node-work-"
}

variable "controlplane_cpu" {
  type = number
  default = 2
  description = ""
}

variable "worker_cpu" {
  type = number
  default = 2
  description = ""
}

variable "controlplane_memory" {
  type = number
  default = 2048
  description = ""
}

variable "worker_memory" {
  type = number
  default = 2048
  description = ""
}

variable "vsphere_template_auth_user" {
  default = "vagrant"
  type = string
  description = ""
}

variable "vsphere_template_auth_pass" {
  default = "vagrant"
  type = string
  description = ""
}

variable "vsphere_template_auth_type" {
  default = "ssh"
  type = string
  description = ""
}

variable "domain" {
  type = string
  description = ""
}

variable "admin_user" {
  type = string
  description = ""
  default = "kube_admin"
}
