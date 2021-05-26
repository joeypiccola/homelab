provider "aws" {
  region = var.app.region # <-- using default here does not work, why?
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.4.0"
    }
  }
}
