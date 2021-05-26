resource "aws_instance" "instance" {
  ami           = "ami-04468e03c37242e1e"
  instance_type = var.app.instance_type
  tags = {
    "Name" = var.app.name
  }
  user_data = templatefile("httpd.tpl",
    {
      name   = var.app.name
      region = var.app.region
  })
  security_groups = [aws_security_group.sg.name]
}
