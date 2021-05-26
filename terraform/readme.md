# terraform

All things terraform.

## current projects being managed here

- Kubernetes cluster
- Various AWS exercises
  - **Objective**: Build webserver farm with HTTPS load balancer. Leverage LetsEncrypt certificate on the front-end. Leverage `locals`.
    - name web-a.joeypiccola-aws.com ✅
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
  - **Objective**: Get LetsEncrypt cert, import into AWS ACM
    - get cert ✅
    - importing to AWS ACM and output `arn` ✅
