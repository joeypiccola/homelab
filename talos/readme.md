# talos

- [talos](#talos)
  - [install ctl](#install-ctl)
  - [ipam and dns](#ipam-and-dns)
    - [plan out ips](#plan-out-ips)
    - [create a dns record for `talos.piccola.us` that points to your VIP](#create-a-dns-record-for-talospiccolaus-that-points-to-your-vip)
  - [talos config and cluster bootstrapping](#talos-config-and-cluster-bootstrapping)
    - [generate secrets](#generate-secrets)
    - [get control plane patch](#get-control-plane-patch)
      - [update the VIP in the `cp.patch.yaml` file](#update-the-vip-in-the-cppatchyaml-file)
    - [generate config](#generate-config)
    - [update talosconfig's nodes and endpoints](#update-talosconfigs-nodes-and-endpoints)
    - [set env var for talosconfig](#set-env-var-for-talosconfig)
    - [apply config to each node (ips retrieved when the systems came up)](#apply-config-to-each-node-ips-retrieved-when-the-systems-came-up)
    - [bootstrap the first node (you do this once on a single node)](#bootstrap-the-first-node-you-do-this-once-on-a-single-node)
    - [merge kubeconfig with ~/.kube/config](#merge-kubeconfig-with-kubeconfig)
    - [run some commands](#run-some-commands)
  - [vnware tools](#vnware-tools)
    - [leverage `talosctl` to create a new config with the role `os:admin`](#leverage-talosctl-to-create-a-new-config-with-the-role-osadmin)
    - [leverage `kubectl` to apply the vmtoolsd-secret.yaml manifest](#leverage-kubectl-to-apply-the-vmtoolsd-secretyaml-manifest)
    - [watch the pods](#watch-the-pods)
    - [the secret](#the-secret)

## install ctl

```bash
curl -Lo /usr/local/bin/talosctl https://github.com/talos-systems/talos/releases/latest/download/talosctl-$(uname -s | tr "[:upper:]" "[:lower:]")-amd64
chmod +x /usr/local/bin/talosctl
talosctl version
```

## ipam and dns

### plan out ips

this is just for a three node (control plane only) cluster

| use | ip                                                    |
|-----|-------------------------------------------------------|
| cp0 | tbd, for now you'll get this when the system comes up |
| cp1 | tbd, for now you'll get this when the system comes up |
| cp2 | tbd, for now you'll get this when the system comes up |
| vip | 10.0.3.150                                            |

### create a dns record for `talos.piccola.us` that points to your VIP

```
➜ nslookup talos.piccola.us
Server:         10.0.3.24
Address:        10.0.3.24#53

Name:   talos.piccola.us
Address: 10.0.3.150
```

## talos config and cluster bootstrapping

### generate secrets

`talosctl gen secrets -o secrets.yaml`

### get control plane patch

this is what is leveraged to get vmware tools installed

`curl -fsSLO https://raw.githubusercontent.com/siderolabs/talos/master/website/content/v1.2/talos-guides/install/virtualized-platforms/vmware/cp.patch.yaml`

#### update the VIP in the `cp.patch.yaml` file

this is also setting DHCP

```yaml
vip:
  ip: 10.0.3.150
```

### generate config

`talosctl gen config --with-secrets secrets.yaml talos https://talos.piccola.us:6443 --config-patch-control-plane @cp.patch.yaml`

### update talosconfig's nodes and endpoints

get the nodes' ips from console

```yaml
context: talos
contexts:
    talos:
        endpoints:
            - 10.0.3.150
        nodes:
            - 10.0.3.51
            - 10.0.3.110
            - 10.0.3.112
        ca: "< removed >"
        crt: "< removed >"
        key: "< removed >"

```

### set env var for talosconfig

this prevents having to specify `--talosconfig` in `talosctl --talosconfig=./talosconfig` each time. consider using `direnv` and stashing this in a `.envrc` file.

`export TALOSCONFIG=./talosconfig`

### apply config to each node (ips retrieved when the systems came up)

wait till each node finished booting from the ISO

```
talosctl apply-config --insecure --nodes 10.0.3.51 --file controlplane.yaml
talosctl apply-config --insecure --nodes 10.0.3.110 --file controlplane.yaml
talosctl apply-config --insecure --nodes 10.0.3.112 --file controlplane.yaml
```

### bootstrap the first node (you do this once on a single node)

this takes some time, the cluster slowly reconciles itself

`talosctl bootstrap --nodes 10.0.3.51`

### merge kubeconfig with ~/.kube/config

`talosctl kubeconfig -n 10.0.3.51`

### run some commands

```
Documents/projects/talos
➜ talosctl get members
NODE         NAMESPACE   TYPE     ID              VERSION   HOSTNAME        MACHINE TYPE   OS               ADDRESSES
10.0.3.51    cluster     Member   talos-5lk-xfm   1         talos-5lk-xfm   controlplane   Talos (v1.3.0)   ["10.0.3.112"]
10.0.3.51    cluster     Member   talos-ka0-svz   3         talos-ka0-svz   controlplane   Talos (v1.3.0)   ["10.0.3.51","10.0.3.150"]
10.0.3.51    cluster     Member   talos-v1j-6ql   1         talos-v1j-6ql   controlplane   Talos (v1.3.0)   ["10.0.3.110"]
10.0.3.110   cluster     Member   talos-5lk-xfm   1         talos-5lk-xfm   controlplane   Talos (v1.3.0)   ["10.0.3.112"]
10.0.3.110   cluster     Member   talos-ka0-svz   2         talos-ka0-svz   controlplane   Talos (v1.3.0)   ["10.0.3.51","10.0.3.150"]
10.0.3.110   cluster     Member   talos-v1j-6ql   3         talos-v1j-6ql   controlplane   Talos (v1.3.0)   ["10.0.3.110"]
10.0.3.112   cluster     Member   talos-5lk-xfm   3         talos-5lk-xfm   controlplane   Talos (v1.3.0)   ["10.0.3.112"]
10.0.3.112   cluster     Member   talos-ka0-svz   2         talos-ka0-svz   controlplane   Talos (v1.3.0)   ["10.0.3.51","10.0.3.150"]
10.0.3.112   cluster     Member   talos-v1j-6ql   1         talos-v1j-6ql   controlplane   Talos (v1.3.0)   ["10.0.3.110"]
```

```
Documents/projects/talos
➜ k get nodes
NAME            STATUS   ROLES           AGE    VERSION
talos-5lk-xfm   Ready    control-plane   124m   v1.26.0
talos-ka0-svz   Ready    control-plane   124m   v1.26.0
talos-v1j-6ql   Ready    control-plane   124m   v1.26.0
```

```
➜ talosctl -n 10.0.3.51 dashboard
```

## vnware tools

at this point the daemon set that was patched in as part of `cp.patch.yaml` isin't happy. the required secret `talos-vmtoolsd-config` doesn't exist. switch to the `kube-system` namespace and view the `talos-vmtoolsd` daemonset. it is sad (`0` ready) and pods are stuck in `ContainerCreating`.

```
Documents/projects/talos
➜ kubectl config set-context --current --namespace=kube-system
Context "admin@talos" modified.
```

```
Documents/projects/talos
➜ k get daemonsets talos-vmtoolsd
NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
talos-vmtoolsd   3         3         0       3            3           <none>          163m
```

```
Documents/projects/talos
➜ k get pods | grep vmtoolsd
talos-vmtoolsd-gz4ql                    0/1     ContainerCreating   0              156m
talos-vmtoolsd-msg2j                    0/1     ContainerCreating   0              156m
talos-vmtoolsd-slrdd                    0/1     ContainerCreating   0              156m
```

### leverage `talosctl` to create a new config with the role `os:admin`

`talosctl -n 10.0.3.51 config new vmtoolsd-secret.yaml --roles os:admin`

### leverage `kubectl` to apply the vmtoolsd-secret.yaml manifest

note, deployed to `kube-system` namespace named `talos-vmtoolsd-config` with data key `talosconfig`

`kubectl -n kube-system create secret generic talos-vmtoolsd-config --from-file=talosconfig=./vmtoolsd-secret.yaml`

### watch the pods

they should transition to `Running`

```
Documents/projects/talos took 6s
➜ k get pods --watch
```

### the secret

get the secret and decode it, note the data key is `talosconfig`. the secret should be the exact contents of `vmtoolsd-secret.yaml`.

```
➜ k get secret talos-vmtoolsd-config -o yaml
apiVersion: v1
data:
  talosconfig: Y29udGV4dDogYWRtaW5AdGFs..............
```

```
echo 'Y29udGV4dDogYWRtaW5AdGFs..............' | base64 --decode
```
