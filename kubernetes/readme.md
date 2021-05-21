# kubernetes

All things kubernetes (mostly). See terraform\k8s for how the infrastructure is built\managed.

## kubespray

### install

Clone [kubespray](https://kubespray.io/), cd to dir, and install requirements.

```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
pip3 install -r requirements.txt
```

### inventory

Build you inventory. This matches your terraform deployments.

```bash
declare -a IPS=(10.0.3.161 10.0.3.162 10.0.3.151 10.0.3.152 10.0.3.153)
CONFIG_FILE=inventory/mycluster/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

This creates `kubespray/inventory/mycluster/hosts.yml`. Modify as needed to ensure masters, nodes, and etcd is setup as needed.

### additional setup

Edit `group_vars/k8s-cluster/k8s-cluster.yml` and set `kubeconfig_localhost` to `true`. This will copy over an `admin.conf` to `kubespray/inventory/mycluster/artifacts/admin.conf` during the ansible run.

### building

Build using ansible leveraging the private key over in ansible.

Test connection

`ansible -i ./inventory/mycluster/hosts.yml all -m ping --key-file=/Users/jpiccola/Documents/github/homelab/ansible/keys/id_rsa -u kube_admin`

Build it!

`ansible-playbook -i ./inventory/mycluster/hosts.yml -u kube_admin -b --key-file=/Users/jpiccola/Documents/github/homelab/ansible/keys/id_rsa cluster.yml`

#### additional building

Use `pb_k8s.yml` playbook to install NFS on all nodes. You'll need to change `ansible_user` in `groups_vars/all.yml` to `kube_admin`. Figure this out, cd to ansible directory.

`ansible-playbook -i ../kubernetes/kubespray/inventory/mycluster/hosts.yml pb_k8s.yml`

## kubectl

### config

You have two options here 1) get the `admin.conf` downloaded from kubespray or 2) get it manually via SSH.

SSH to a master and get `/etc/kubernetes/admin.conf` and place it locally `./mycluster.conf`. Export `KUBECONFIG` as shown below. Now you can run `kubectl` commands (e.g. `kubectl cluster-info`).

Either way, once you got it `export` it as `KUBECONFIG`.

```bash
export KUBECONFIG=$PWD/admin.conf
export KUBECONFIG=~/Documents/github/homelab/kubernetes/kubespray/inventory/mycluster/artifacts/admin.conf
```

### notes
