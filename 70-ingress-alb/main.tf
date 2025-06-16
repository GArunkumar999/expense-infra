# creating application load balancer for backend

module "ingress-alb" {
  source                     = "terraform-aws-modules/alb/aws"
  enable_deletion_protection = false
  internal                   = false
  create_security_group      = false
  security_groups            = [data.aws_ssm_parameter.alb_ingress_sg_id.value]
  name                       = "ingress-alb"
  vpc_id                     = data.aws_ssm_parameter.vpc_id.value
  subnets                    = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  tags = {
    Name = "${var.project}-${var.environment}-ingress-alb"
  }
}

# creating listener for backend alb for fixed response

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.ingress-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_ssm_parameter.alb_ingress_certificate_arn.value


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>HELLO FROM WEB ALB</h1>"
      status_code  = "200"
    }
  }
}

# creating backend target group

resource "aws_lb_target_group" "frontend_tg" {
  name        = "nginx"
  target_type = "ip"
  port        = "8080"
  protocol    = "HTTP"
  #The deregistration delay is the amount of time the load balancer waits before marking a target as "deregistered" after it has been removed from the target group. 
  deregistration_delay = 60
  vpc_id               = data.aws_ssm_parameter.vpc_id.value
  health_check {
    healthy_threshold   = 2
    interval            = 10
    path                = "/"
    port                = "8080"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

}

# creating listner rule for backend alb to target backend target group

resource "aws_lb_listener_rule" "frontend_header" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }


  condition {
    host_header {
      values = ["${var.project}-${var.environment}.devopslearning.fun"]
    }
  }
}


