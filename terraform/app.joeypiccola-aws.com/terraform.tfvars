app = {
  instance_type = "t2.micro"
  name          = "web-a"
  region        = "us-west-1"
  zone          = "joeypiccola-aws.com"
}

acme_email = "joey.piccola@gmail.com"
cert_sans  = ["web-test", "web-dev","web-stage"]
