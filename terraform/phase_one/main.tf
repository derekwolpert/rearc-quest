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




# variable "image_name" {
#   type = string
# }

# module "codecommit-cicd" {
#   source                    = "git::https://github.com/slalompdx/terraform-aws-codecommit-cicd.git?ref=master"
#   repo_name                 = "rearc-quest-repo"
#   organization_name         = "derekwolpert"
#   repo_default_branch       = "master"
#   aws_region                = "us-east-2"
#   char_delimiter            = "-"
#   environment               = "dev"
#   build_timeout             = "5"
#   build_compute_type        = "BUILD_GENERAL1_SMALL"
#   build_image               = "aws/codebuild/standard:3.0"
#   build_privileged_override = "true"
#   test_buildspec            = "buildspec_test.yml"
#   package_buildspec         = "buildspec.yml"
#   force_artifact_destroy    = "true"
# }

# resource "aws_ecr_repository" "image_repository" {
#   name = var.image_name
# }

# resource "aws_iam_role_policy" "codebuild_policy" {
#   name = "serverless-codebuild-automation-policy"
#   role = module.codecommit-cicd.codebuild_role_name

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "ecr:BatchCheckLayerAvailability",
#         "ecr:CompleteLayerUpload",
#         "ecr:GetAuthorizationToken",
#         "ecr:InitiateLayerUpload",
#         "ecr:PutImage",
#         "ecr:UploadLayerPart"
#       ],
#       "Resource": "*",
#       "Effect": "Allow"
#     }
#   ]
# }
# POLICY

# }

# output "repo_url" {
#   depends_on = [module.codecommit-cicd]
#   value      = module.codecommit-cicd.clone_repo_https
# }

# output "codepipeline_role" {
#   depends_on = [module.codecommit-cicd]
#   value      = module.codecommit-cicd.codepipeline_role
# }

# output "codebuild_role" {
#   depends_on = [module.codecommit-cicd]
#   value      = module.codecommit-cicd.codebuild_role
# }

# output "ecr_image_respository_url" {
#   depends_on = [aws_ecr_repository.image_repository]
#   value      = aws_ecr_repository.image_repository.repository_url
# }

