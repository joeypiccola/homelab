# cert-manager

## Setup helm.

`helm repo add jetstack https://charts.jetstack.io`

`helm repo update`

## config

Setup cert-manager prerequisites.

- Namespace

`k apply -f setup.yml`

Below deployment with all the `--set` is specific to using the annotation `kubernetes.io/tls-acme: "true"` as described under [Supported Annotations](https://cert-manager.io/docs/usage/ingress/#supported-annotations).

`helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.16.0 --set installCRDs=true --set ingressShim.defaultIssuerName=letsencrypt-prod --set ingressShim.defaultIssuerKind=ClusterIssuer --set ingressShim.defaultIssuerGroup=cert-manager.io`

Create cloud flare secret. This file `cloudflare-secret.yml` is excluded from this repo.

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
  namespace: cert-manager
type: Opaque
stringData:
  api-token: <removed>
```


`k apply -f cloudflare-secret.yml`

Create the ClusterIssuer.

`k apply -f issuer.yml`

Check it out.

`k get pods --namespace cert-manager`

## kubectl plugin

This does not work, [link](https://cert-manager.io/docs/usage/kubectl-plugin/).

```bash
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v0.16.1/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/local/bin
```

Delete it

```
1840  kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.16.0/cert-manager.yaml
 1841  helm --namespace cert-manager delete cert-manager
 1842  kubectl delete namespace cert-manager
 1843  kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.16.0/cert-manager.crds.yaml
 1844  kubectl delete apiservice v1beta1.webhook.cert-manager.io
```
