variable "sg_allowed_ports" {
  type    = list(number)
  default = [80, 22, 443]
}

resource "aws_security_group" "sg" {
  name = "${var.name}-sg"
  dynamic "ingress" {
    iterator = port
    for_each = var.sg_allowed_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "TCP"
      from_port   = port.value
      to_port     = port.value
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.sg_allowed_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "TCP"
      from_port   = port.value
      to_port     = port.value
    }
  }
}
