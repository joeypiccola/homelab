# gen private key
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# register with acme
resource "acme_registration" "acme_reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.acme_email
}

# request a cert
resource "acme_certificate" "acme_crt" {
  account_key_pem           = acme_registration.acme_reg.account_key_pem
  common_name               = local.cert_common
  subject_alternative_names = length(local.cert_sans) > 0 ? local.cert_sans : [local.cert_common]
  dns_challenge {
    provider = "route53"
  }
}

# add it to AWS ACM
resource "aws_acm_certificate" "aws_crt" {
  private_key       = acme_certificate.acme_crt.private_key_pem
  certificate_body  = acme_certificate.acme_crt.certificate_pem
  certificate_chain = "${acme_certificate.acme_crt.certificate_pem}${acme_certificate.acme_crt.issuer_pem}"
  lifecycle {
    create_before_destroy = true
  }
}
