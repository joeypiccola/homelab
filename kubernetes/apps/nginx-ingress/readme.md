# nginx-ingress

## config

Setup nginx-ingress prerequisites.

- Namespace

`k apply -f setup.yml`

Install nginx-ingress via helm leveraging the values in `values.yml`.

`helm install nginx-ingress -f values.yml --namespace nginx-ingress stable/nginx-ingress`
