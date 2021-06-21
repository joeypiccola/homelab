# create the iot cert used by the thing attached to the policy
resource "aws_iot_certificate" "cert" {
  active = true
}

resource "local_file" "certificate_pem" {
    content     = aws_iot_certificate.cert.certificate_pem
    filename = "${path.module}/iot_cert/cert.pem"
}

resource "local_file" "public_key" {
    content     = aws_iot_certificate.cert.public_key
    filename = "${path.module}/iot_cert/public_key.pem"
}

resource "local_file" "private_key" {
    content     = aws_iot_certificate.cert.private_key
    filename = "${path.module}/iot_cert/private_key.pem"
}
