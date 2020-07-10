terraform {
  backend "gcs" {
    bucket = "jpi-homelab-tfstate"
    prefix = "terraform/state/k8s"
    credentials = "/Users/jpiccola/Documents/github/homelab/terraform/keys/svc-tfstate.json"
  }
}
