provider "aws" {
  region = var.region
}

provider "acme" {
  server_url = var.lets_encrypt_env == "production" ? var.lets_encrypt_prd_url : var.lets_encrypt_stg_url
}

terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.4.0"
    }
  }
}
