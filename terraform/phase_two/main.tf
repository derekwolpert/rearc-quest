variable "aws_region" {
  description = "Enter in a value for aws-region (e.g. us-east-1, us-west-2, etc.)"
  type = string
}

provider "aws" {
  region = var.aws_region
}

output "ecs_alb_dns" {
  depends_on = [aws_alb.rearc-quest-alb]
  value = aws_alb.rearc-quest-alb.dns_name
}