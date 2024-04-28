# vsphere data
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_portgroup
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# control plane node build out
resource "vsphere_virtual_machine" "control_plane" {
  count = var.controlplane_count

  name             = "${var.controlplane_name_prefix}${format("%02s", count.index + 1)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder

  num_cpus = var.controlplane_cpu
  memory   = var.controlplane_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.controlplane_name_prefix}${format("%02s", count.index + 1)}"
        domain    = var.domain
      }

      dns_server_list = var.dns_servers
      #dns_suffix_list = [var.kube_network.domain]

      network_interface {
        ipv4_address = cidrhost("${var.cluster_subnet}/${var.cluster_netmask}", var.cluster_start_address + count.index)
        ipv4_netmask = var.cluster_netmask
      }

      ipv4_gateway = var.cluster_gateway
    }
  }

  provisioner "file" {
    source      = "./files/authorized_keys"
    destination = "/tmp/authorized_keys"

    connection {
      type        = var.vsphere_template_auth_type
      user        = var.vsphere_template_auth_user
      password    = var.vsphere_template_auth_pass
      host        = cidrhost("${var.cluster_subnet}/${var.cluster_netmask}", var.cluster_start_address + count.index)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --disabled-password --gecos \"\" ${var.admin_user}",
      "sudo mkdir -p /home/${var.admin_user}/.ssh",
      "sudo mv /tmp/authorized_keys /home/${var.admin_user}/.ssh/authorized_keys",
      "sudo chmod 0600 /home/${var.admin_user}/.ssh/authorized_keys",
      "sudo chown -R ${var.admin_user}:${var.admin_user} /home/${var.admin_user}/.ssh",
      "sudo bash -c 'echo \"${var.admin_user} ALL=NOPASSWD:ALL\" > /etc/sudoers.d/${var.admin_user}'"
    ]
    connection {
      type        = var.vsphere_template_auth_type
      user        = var.vsphere_template_auth_user
      password    = var.vsphere_template_auth_pass
      host        = cidrhost("${var.cluster_subnet}/${var.cluster_netmask}", var.cluster_start_address + count.index)
    }
  }

}

# worker node build out
resource "vsphere_virtual_machine" "worker" {
  count = var.worker_count

  name             = "${var.worker_name_prefix}${format("%02s", count.index + 1)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder

  num_cpus = var.worker_cpu
  memory   = var.worker_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.worker_name_prefix}${format("%02s", count.index + 1)}"
        domain    = var.domain
      }

      dns_server_list = var.dns_servers
      #dns_suffix_list = [var.kube_network.domain]

      network_interface {
        ipv4_address = cidrhost("${var.cluster_subnet}/${var.cluster_netmask}", var.cluster_start_address + var.controlplane_count + count.index)
        ipv4_netmask = var.cluster_netmask
      }

      ipv4_gateway = var.cluster_gateway
    }
  }

  provisioner "file" {
    source      = "./files/authorized_keys"
    destination = "/tmp/authorized_keys"

    connection {
      type        = var.vsphere_template_auth_type
      user        = var.vsphere_template_auth_user
      password    = var.vsphere_template_auth_pass
      host        = cidrhost("${var.cluster_subnet}/${var.cluster_netmask}", var.cluster_start_address + var.controlplane_count + count.index)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --disabled-password --gecos \"\" ${var.admin_user}",
      "sudo mkdir -p /home/${var.admin_user}/.ssh",
      "sudo mv /tmp/authorized_keys /home/${var.admin_user}/.ssh/authorized_keys",
      "sudo chmod 0600 /home/${var.admin_user}/.ssh/authorized_keys",
      "sudo chown -R ${var.admin_user}:${var.admin_user} /home/${var.admin_user}/.ssh",
      "sudo bash -c 'echo \"${var.admin_user} ALL=NOPASSWD:ALL\" > /etc/sudoers.d/${var.admin_user}'"
    ]
    connection {
      type        = var.vsphere_template_auth_type
      user        = var.vsphere_template_auth_user
      password    = var.vsphere_template_auth_pass
      host        = cidrhost("${var.cluster_subnet}/${var.cluster_netmask}", var.cluster_start_address + var.controlplane_count + count.index)
    }
  }

}
