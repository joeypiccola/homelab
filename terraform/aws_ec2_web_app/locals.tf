locals {
  cert_sans   = [for i in var.cert_sans : "${i}.${var.zone}"]
  cert_common = "${var.name}.${var.zone}"
}
