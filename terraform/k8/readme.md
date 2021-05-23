# terraform k8s

All things Terraform k8s.

## remote state

Your state is in GCS. The following was used to create the bucket, service account, service account keys, and finally grant permissions to the bucket for the service account.

```bash
gcloud projects list
PROJECT_NAME="<PROJECT-NAME>"
gcloud config set project ${PROJECT_NAME}
PROJECT_ID=$(gcloud config get-value project)
gsutil mb gs://${PROJECT_ID}-tfstate
gsutil versioning set on gs://${PROJECT_ID}-tfstate
gcloud iam service-accounts create svc-tfstate --display-name "Terraform State Service Account"
gcloud iam service-accounts keys create /Users/jpiccola/Documents/github/homelab/terraform/keys/svc-tfstate.json --iam-account svc-tfstate@${PROJECT_NAME}.iam.gserviceaccount.com
gsutil iam ch serviceAccount:svc-tfstate@${PROJECT_NAME}.iam.gserviceaccount.com:roles/storage.objectAdmin gs://${PROJECT_NAME}-tfstate
```

The service account key for accessing the bucket is located at `.\keys\svc-tfstate.json` and is exclude in this repo.

## usage

```bash
cd .\k8
terraform init # if you haven't already done so
terraform plan
terraform apply
```

## tfvars

The following `terraform.tfvars` is not included in this repo. Still trying to figure out secrets.

```tfvars
vsphere_connection = {
  allow_unverified_ssl = true
  password             = "-"
  server               = "-"
  user                 = "-"
}

virtual_machine_template = {
  name                = "ubuntu18-packer"
  connection_type     = "ssh"
  connection_user     = "vagrant"
  connection_password = "vagrant"
}

vsphere_build = {
  cluster    = "BC1"
  datacenter = "Basement"
  datastore  = "freenas_datastore_1"
  folder     = "ad.piccola.us/production/kubernetes"
}

kube_network = {
  dns_servers               = "10.0.3.24"
  domain                    = "piccola.us"
  ipv4_master_gateway       = "10.0.3.1"
  ipv4_master_netmask       = 24
  ipv4_master_network       = "10.0.3.0"
  ipv4_master_start_address = "161"
  ipv4_node_gateway         = "10.0.3.1"
  ipv4_node_netmask         = 24
  ipv4_node_network         = "10.0.3.0"
  ipv4_node_start_address   = "151"
  portgroup                 = "VLAN3_primary_LAN"
}
```
