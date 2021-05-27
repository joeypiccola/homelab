# aws_ec2_web_app

Below is an example of how to use this module.

```hcl
module "aws_ec2_web_app" {
  source           = "../aws_ec2_web_app"
  name             = "web-a"
  zone             = "joeypiccola-aws.com"
  region           = "us-west-1"
  acme_email       = "joey.piccola@gmail.com"
  cert_sans        = ["web-test", "web-dev","web-stage"]
  lets_encrypt_env = "staging"
}

output "app_url" {
  value = module.aws_ec2_web_app.app_url
}
```
