# k8s

The terraform module `modules\k8s_vsphere` can be used to create all the necessary VM infrastructure to support a Kubernetes cluster in vSphere . To get started simply create a `main.tf` in the root of this directory with the following. There are many optional variables not shown below, see `modules\k8s_vsphere\variables.tf`.

```hcl
module "k8s_vsphere" {
  source                       = "./modules/k8s_vsphere"
  vsphere_server               = "vcenter"
  vsphere_allow_unverified_ssl = true
  vsphere_cluster              = "BC1"
  vsphere_datacenter           = "Basement"
  vsphere_portgroup            = "VLAN3_primary_LAN"
  vsphere_datastore            = "samsung-970-evo-plus"
  vsphere_folder               = "ad.piccola.us/production/kubernetes"
  vsphere_user                 = "-"
  vsphere_password             = "-"
  vsphere_template             = "ubuntu18-packer"
  controlplane_count           = 3
  worker_count                 = 2
  cluster_subnet               = "10.0.3.0"
  cluster_gateway              = "10.0.3.1"
  cluster_netmask              = 24
  cluster_start_address        = 150
  dns_servers                  = ["10.0.3.24"]
  domain                       = "piccola.us"
}
```

An example of the directory layout. Note `files\authorized_keys`.

```plaintext
├── files
│   └── authorized_keys
├── main.tf
├── modules
│   └── k8s_vsphere
│       ├── nodes.tf
│       ├── providers.tf
│       └── variables.tf
└── readme.md
```

## authentication

Initial authentication to the terraform provisioned nodes is handled via the variables `vsphere_template_auth_user`, `vsphere_template_auth_pass`, and `vsphere_template_auth_type`. These credentials default to `vagrant\vagrant` and are setup during the template creation via Packer (TBD). These credentials are used by terraform via SSH to logon and create the user specified via the variable `admin_user`. A public SSH key `files\authorized_keys` is copied to this user's home directory `/home/${var.admin_user}/.ssh/authorized_keys`. The user is setup for password authentication and added to the sudoers file.

## naming and networking

Control plane nodes assume the following name `node-ctrl-{i}` and worker nodes `node-work-{i}`.IP addressing happens sequentially starting at the provided `cluster_start_address`. The sequence starts from the first control plane node to the last worker node. For example, if `cluster_start_address` is `150`, `cluster_subnet` is `10.0.3.0`, and you have 3 control plane nodes and 2 worker nodes the names and IPs would be as follows. Yes, this means there will be issues if you increase your control plane node count and re-run terraform. However, the intent of this project is to easily be able to redeploy all the things and not care if you have to `destroy` it to change node counts.

| name        | IP         |
|-------------|------------|
| node-ctrl-1 | 10.0.3.150 |
| node-ctrl-2 | 10.0.3.151 |
| node-ctrl-3 | 10.0.3.152 |
| node-work-1 | 10.0.3.153 |
| node-work-2 | 10.0.3.154 |

## todo

- Not a huge fan of the duplicate `vsphere_virtual_machine` resource deceleration in `nodes.tf`. Perhaps consider having a total cluster count variable paired with either a control plane count OR worker count. If for example you go with control plane count of 3 and a total cluster count of 5, then the first 3 out of 5 would be control planes and the remainder would be workers. Could use some kind of ternary in the `name` and `host_name` parameters to switch the `name_prefix` logic ¯\_(ツ)_/¯. Same goes for other role specific settings, memory and cpu.
