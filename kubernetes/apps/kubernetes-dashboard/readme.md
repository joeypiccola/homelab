# kubernetes-dashboard

## config

Setup kubernetes-dashboard prerequisites.

- Namespace
- ServiceAccount
- ClusterRoleBinding
- ClusterRole

`k apply -f setup.yml`

Install kubernetes-dashboard via helm leveraging the values in `values.yml`.

`helm install kubernetes-dashboard -f values.yml kubernetes-dashboard/kubernetes-dashboard --namespace kubernetes-dashboard`

Get the secrets for `kubernetes-dashboard` namespace.

`k get secrets -n kubernetes-dashboard`

Get the token for `dash-admin-user-token-<?>`.

`k describe secret -n kubernetes-dashboard dash-admin-user-token-<?>`

Get ingress info.

`k describe ingress -n kubernetes-dashboard`
