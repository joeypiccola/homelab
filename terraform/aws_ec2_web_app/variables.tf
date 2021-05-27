variable "name" {
  type        = string
  description = "The name used for the web app."
}

variable "region" {
  type        = string
  description = "The region to build the web app in."
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type to use for the web app."
  default     = "t2.micro"
}

variable "zone" {
  type        = string
  description = "The Route53 DNS zone to use."
}

variable "cert_sans" {
  type        = list(any)
  description = "A list of certificate SANs to use e.g. ['web-dev','web-test']."
  default     = []
}

variable "acme_email" {
  type        = string
  description = "The email to use with for LetsEncrypt registration."
}

variable "lets_encrypt_prd_url" {
  type    = string
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "lets_encrypt_stg_url" {
  type    = string
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "lets_encrypt_env" {
  type        = string
  description = "The environment to use for the LetsEncrypt certificate, Valid values are 'production' or 'staging'."
  validation {
    condition     = contains(["production", "staging"], "${var.lets_encrypt_env}")
    error_message = "Valid values for var: lets_encrypt_env are (production, staging)."
  }
}
