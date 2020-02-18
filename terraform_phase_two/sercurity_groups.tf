# Security group for application loadbalancer. Only open ports are 80 and 443,
# since HTTP and HTTPS are the only access points needed for resources using this
# security group.

resource "aws_security_group" "rearc-quest-alb-security-group" {
  name = "rearc-quest-alb-security-group"
  vpc_id = aws_vpc.rearc-quest-vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

# Security group for the ecs cluster. Only open port is 3000 since the Docker image
# is running on port 3000 within the ecs cluster. No other ports are needed for
# resources using this security group.

resource "aws_security_group" "rearc-quest-ecs-security-group" {
  name = "rearc-quest-ecs-security-group"
  vpc_id = aws_vpc.rearc-quest-vpc.id
  
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}