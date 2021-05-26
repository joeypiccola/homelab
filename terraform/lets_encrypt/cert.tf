resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "joey.piccola@gmail.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "web-a.joeypiccola-aws.com"
  subject_alternative_names = ["weba-a.joeypiccola-aws.com"]

  dns_challenge {
    provider = "route53"
  }
}

resource "aws_acm_certificate" "cert" {
  private_key      = acme_certificate.certificate.private_key_pem
  certificate_body = acme_certificate.certificate.certificate_pem
  certificate_chain = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
}

output "cert" {
  value = aws_acm_certificate.cert.arn
}
