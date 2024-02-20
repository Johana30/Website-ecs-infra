resource "aws_lb" "aws-lb" {
  name               = var.lb-name
  internal           = var.inter-ext
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_groups]
  subnets            = [for subnet in var.subnets : subnet]
}

resource "aws_lb_listener" "alb-http" {
  load_balancer_arn = aws_lb.aws-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target.arn
  }
}
//to use the following code is needed a https certificate /check variables files as well

# resource "aws_lb_listener" "alb-https" {
#   load_balancer_arn = aws_lb.aws-lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb-target.arn
#   }
# }

resource "aws_lb_target_group" "lb-target" {
  name        = var.target-name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  stickiness {
    type            = "app_cookie"
    enabled         = true
    cookie_duration = 86400
    cookie_name     = "ASP.NET_SessionId"
  }
  health_check {
    matcher  = "200"
    path     = "/"
    protocol = "HTTPS"
  }
}
