# terraform

All things terraform.

## current projects being managed here

- Kubernetes cluster

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
