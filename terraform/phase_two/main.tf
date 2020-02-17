variable "aws_region" {
  description = "Enter in a value for aws-region (e.g. us-east-1, us-west-2, etc.)"
  type = string
}

variable "ecr_repo_url" {
  description = "Enter in the url of the ecr repo created at the end of phase one (e.g. xxxxxxxxxxxx.dkr.ecr.xx-xxxx-x.amazonaws.com/rearc-quest-container-repo)"
  type = string
}

provider "aws" {
  region = var.aws_region
}

output "ecs_alb_dns" {
  value = aws_alb.rearc-quest-alb.dns_name
}