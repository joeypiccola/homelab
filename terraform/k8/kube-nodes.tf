resource "vsphere_virtual_machine" "kube-nodes" {
  count = var.kube_config.node_count

  name             = "${var.kube_nodes.node_name_prefix}-${format("%02s", count.index + 1)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_build.folder

  num_cpus = var.kube_nodes.cpus
  memory   = var.kube_nodes.memory
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
        host_name = "${var.kube_nodes.node_name_prefix}-${format("%02s", count.index + 1)}"
        domain    = var.kube_network.domain
      }

      dns_server_list = [var.kube_network.dns_servers]
      dns_suffix_list = [var.kube_network.domain]

      network_interface {
        ipv4_address = cidrhost("${var.kube_network.ipv4_node_network}/${var.kube_network.ipv4_node_netmask}", var.kube_network.ipv4_node_start_address + count.index)
        ipv4_netmask = var.kube_network.ipv4_node_netmask
      }

      ipv4_gateway = var.kube_network.ipv4_node_gateway
    }
  }

  provisioner "file" {
    source      = "./files/authorized_keys"
    destination = "/tmp/authorized_keys"

    connection {
      type        = var.virtual_machine_template.connection_type
      user        = var.virtual_machine_template.connection_user
      password    = var.virtual_machine_template.connection_password
      host        = cidrhost("${var.kube_network.ipv4_node_network}/${var.kube_network.ipv4_node_netmask}", var.kube_network.ipv4_node_start_address + count.index)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --disabled-password --gecos \"\" ${var.kube_config.admin_user}",
      "sudo mkdir -p /home/${var.kube_config.admin_user}/.ssh",
      "sudo mv /tmp/authorized_keys /home/${var.kube_config.admin_user}/.ssh/authorized_keys",
      "sudo chmod 0600 /home/${var.kube_config.admin_user}/.ssh/authorized_keys",
      "sudo chown -R ${var.kube_config.admin_user}:${var.kube_config.admin_user} /home/${var.kube_config.admin_user}/.ssh",
      "sudo bash -c 'echo \"${var.kube_config.admin_user} ALL=NOPASSWD:ALL\" > /etc/sudoers.d/${var.kube_config.admin_user}'"
    ]
    connection {
      type        = var.virtual_machine_template.connection_type
      user        = var.virtual_machine_template.connection_user
      password    = var.virtual_machine_template.connection_password
      host        = cidrhost("${var.kube_network.ipv4_node_network}/${var.kube_network.ipv4_node_netmask}", var.kube_network.ipv4_node_start_address + count.index)
    }
  }

}
