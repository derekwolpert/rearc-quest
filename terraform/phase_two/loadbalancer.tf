resource "aws_alb" "rearc-quest-alb" {
  name               = "rearc-quest-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rearc-quest-alb-security-group.id]
  subnets            = [aws_subnet.rearc-quest-subnet-1.id, aws_subnet.rearc-quest-subnet-2.id, aws_subnet.rearc-quest-subnet-3.id]
}

resource "aws_alb_target_group" "rearc-quest-target-group" {
  name     = "rearc-quest-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   =  aws_vpc.rearc-quest-vpc.id
  target_type = "ip"

  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200"
  }

  depends_on = [aws_alb.rearc-quest-alb]
}

resource "aws_iam_server_certificate" "rearc-quest-ssl-cert" {
  name = "rearc-quest-ssl-cert"
  certificate_body = file("self_signed_ssl_cert/public.pem")
  private_key = file("self_signed_ssl_cert/private.pem")
}

resource "aws_alb_listener" "rearc-quest-http-listener" {
  load_balancer_arn = aws_alb.rearc-quest-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    # type = "redirect"

    # redirect {
    #   port        = "443"
    #   protocol    = "HTTPS"
    #   status_code = "HTTP_301"
    # }
    
    target_group_arn = aws_alb_target_group.rearc-quest-target-group.arn
    type = "forward"
  }
}

resource "aws_alb_listener" "rearc-quest-https-listener" {
  load_balancer_arn = aws_alb.rearc-quest-alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_iam_server_certificate.rearc-quest-ssl-cert.arn

  default_action {
    target_group_arn = aws_alb_target_group.rearc-quest-target-group.arn
    type = "forward"
  }
}