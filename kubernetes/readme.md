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

### building

Build using ansible leveraging the private key over in ansible.

`ansible-playbook -i ./inventory/mycluster/hosts.yml -u kube_admin -b --key-file=/Users/jpiccola/Documents/github/homelab/ansible/keys/id_rsa cluster.yml`

## kubectl

### config

SSH to a master and get `/etc/kubernetes/admin.conf` and place it locally `./mycluster.conf`. Export `KUBECONFIG` as shown below. Now you can run `kubectl` commands (e.g. `kubectl cluster-info`).

```bash
export KUBECONFIG=$PWD/mycluster.conf
```

## kubernets dashboard

Deploy the dashboard.

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml`

Create a service account to access the dashboard.

`kubectl create serviceaccount dashboard-admin-sa`

Create a cluster role binding for the `dashboard-admin-sa` service account to access the dashboard. Binding to `cluster-admin` :( <- prob not a good thing.

`kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa`

Get the service account's token

```bash
kubectl get secrets
kubectl describe secret dashboard-admin-sa-token-mbs6n
```

Create a local proxy.

`kubectl proxy`

Access the dashboard via the URL below using the token retrieved via `kubectl describe secret`.

[http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
