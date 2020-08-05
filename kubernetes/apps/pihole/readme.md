# pihole

## config

Setup pihole helm prerequisites.

`helm repo add mojo2600 https://mojo2600.github.io/pihole-kubernetes/`

`helm repo update`

Setup pihole prerequisites.

- Namespace
- PersistentVolume
- PersistentVolumeClaim

`k apply -f setup.yml`

Install pihole via helm leveraging the values in `values.yml`.

`helm install pihole-kubernetes -f values.yml mojo2600/pihole --namespace pihole`
