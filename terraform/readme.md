# terraform

All things terraform.

## current projects being managed here

- Kubernetes cluster
- Various AWS exercises
  - **Objective**: Build a Terraform module that creates an EC2 web server instance. The instance should be accessible via a load balancer that terminates HTTPS leveraging a LetsEncrypt certificate (user defined LetsEncrypt staging or production environment). The app should be accessible via an AWS Route53 dns record tied to the load balancer. Leverage `locals` where possible, use variable input validation, ternary conditions, and dynamic blocks.
    - More info: [aws_ec2_web_app module](https://github.com/joeypiccola/homelab/tree/master/terraform/aws_ec2_web_app)
    - ec2 web server ✅
    - load balancer ✅
    - load balancer listener ✅
    - load balancer target group ✅
      - target group attachment ✅
    - security group ✅
    - route53 alias record ✅
    - LetsEncrypt cert ✅
      - ensure sans are dynamically added to cert ✅
      - import LetsEncrypt cert to AWS ✅
      - attached to load balancer ✅
  - **Objective**: Build simple configuration that gets a LetsEncrypt cert and imports it into AWS's ACM.
    - More info: [lets_encrypt configuration](https://github.com/joeypiccola/homelab/tree/master/terraform/lets_encrypt)
    - get cert ✅
    - importing to AWS ACM and output `arn` ✅
  - **Objective**: WIP: Build a Terraform module to configure AWS IoT core to forward MQTT messages to an AWS Timestream database. Visualize data in Grafana.
    - More info: [aws_iot_timestream configuration](https://github.com/joeypiccola/homelab/tree/master/terraform/aws_iot_timestream)
