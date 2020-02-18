# AWS IAM role and policy to give appropriate access to pull a Docker image from a ECR
# repo to run within a ECS cluster.

resource "aws_iam_role" "rearc-quest-ecs-task-execution-role" {
  name = "rearc-quest-ecs-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rearc-quest-ecs-task-execution-policy" {
  role = aws_iam_role.rearc-quest-ecs-task-execution-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

# AWS IAM role and policy to give appropriate access for application autoscalling
# features.

resource "aws_iam_role" "rearc-quest-ecs-autoscaling-role" {
  name = "rearc-quest-ecs-autoscaling-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rearc-quest-ecs-autoscaling-policy" {
  role = aws_iam_role.rearc-quest-ecs-autoscaling-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeServices",
        "ecs:UpdateService",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:PutMetricAlarm"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}