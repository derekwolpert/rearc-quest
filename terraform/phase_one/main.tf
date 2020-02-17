variable "aws_region" {
    description = "Enter in a value for aws-region (e.g. us-east-1, us-west-2, etc.)"
    type = string
}

provider "aws" {
  region = var.aws_region
}

output "rearc-quest-container-repo_url" {
  depends_on = [aws_ecr_repository.rearc-quest-container-repo]
  value = aws_ecr_repository.rearc-quest-container-repo.repository_url
}