# Setting "aws_region" to an undefined Terraform variable forces a user to have to
# manually enter in their perfered AWS region each time when using "terraform plan"
# or "terraform apply" commands. The advanage of this slight inconvience prevents
# users from accidently creating services outside of their perfered region.

variable "aws_region" {
  description = "Enter in a value for aws-region (e.g. us-east-1, us-west-2, etc.)"
  type = string
}

# There are no need for access_key and secret_key inputs if your AWS credential are
# stored in their default location utlized in other AWS terminal controlled services
# (e.g. awscli). Terraform should automatically fetch the correct authentication
# information.

provider "aws" {
  region = var.aws_region
}