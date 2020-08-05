# metallb

## config

Setup metallb prerequisites.

- Namespace

`k apply -f setup.yml`

Install metallb via helm leveraging the values in `values.yml`.

`helm install metallb -f values.yml --namespace metallb stable/metallb`
