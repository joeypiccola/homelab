locals {
  cert_sans   = [for i in var.cert_sans : "${i}.${var.app.zone}"]
  cert_common = "${var.app.name}.${var.app.zone}"
}
