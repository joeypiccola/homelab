variable "app" {
  type = map(any)
  default = {
    name          = ""
    zone          = "joeypiccola-aws.com"
    region        = "us-west-1"
    instance_type = "t2.micro"
  }
}

variable "cert_sans" {
  type = list(any)
}

variable "acme_email" {
  type = string
}
