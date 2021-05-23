variable "app" {
  type    = map
  default = {
    auto_scale    = false
    name          = ""
    zone          = ""
    region        = "us-west-1"
    instance_type = "t2.micro"
  }
}