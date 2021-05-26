# get the default vpc for the current region
data "aws_vpc" "default_vpc" {
  default = true
}

# get the subnet ids for the default region vpc
data "aws_subnet_ids" "default_vpc_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}

# create a app load balancer
resource "aws_lb" "lb" {
  name               = "${var.app.name}-lb"
  subnets            = data.aws_subnet_ids.default_vpc_subnets.ids
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.sg.id
  ]
  access_logs {
    bucket  = "value" # required even when false
    enabled = false
  }
}

# make a target group
resource "aws_lb_target_group" "tg" {
  name     = "${var.app.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id
}

# attach instance to target group
resource "aws_lb_target_group_attachment" "tg_attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance.id
  port             = 80
}

# make a listner
resource "aws_lb_listener" "listner" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}