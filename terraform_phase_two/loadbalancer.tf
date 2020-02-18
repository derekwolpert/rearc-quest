# Creates the application load balancer to be used with the project, and configures
# available ports and vpc subnet for public access.  

resource "aws_alb" "rearc-quest-alb" {
  name               = "rearc-quest-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rearc-quest-alb-security-group.id]
  subnets            = [aws_subnet.rearc-quest-subnet-1.id, aws_subnet.rearc-quest-subnet-2.id, aws_subnet.rearc-quest-subnet-3.id]
}

# Defines the connection between the loadbalancer, the vpc and ECS cluster, in how
# the ECS cluster can be accessed from the loadbalancer via the idenified port on
# the given vpc.

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

# Links provided SSL certificate to a AWS server certificate resource to be used with the
# load balancer. Since the SSL cert is self-signed there may be some difficulties accessing 
# the HTTPS access point on some browsers. Therefore, this should be viewed as a proof 
# of concept. In a production environment the cert would be properly confgured to prevent 
# this issue. 

resource "aws_iam_server_certificate" "rearc-quest-ssl-cert" {
  name = "rearc-quest-ssl-cert"
  certificate_body = file("self_signed_ssl_cert/public.pem")
  private_key = file("self_signed_ssl_cert/private.pem")
}

# Creates an access point to the load balancer using HTTP protocol.
# In ideally the HTTP access point would automatically redirect to the HTTPS
# access point, but in this case I have left the HTTP access point accessible to
# the desired target group. 

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

# Creates an access point to the load balancer using HTTPS protocol.

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