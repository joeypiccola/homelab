resource "aws_instance" "instance" {
  #TODO: get latest AMI some how
  ami           = "ami-04468e03c37242e1e"
  instance_type = var.instance_type
  tags = {
    "Name" = var.name
  }
  user_data = templatefile("${path.module}/httpd.tpl",
    {
      name   = var.name
      region = var.region
  })
  security_groups = [aws_security_group.sg.name]
}
