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

resource "aws_ecs_cluster" "rearc-quest-ecs-cluster" {
  name = "rearc-quest-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "rearc-quest-task-log-group" {
  name = "rearc-quest-task-log-group"
}

resource "aws_ecs_task_definition" "rearc-quest-task-definition" {
    family = "rearc-quest-task-definition"
    container_definitions = jsonencode([
        {
            "name": "rearc-quest-container-definition",
            "image": "${aws_ecr_repository.rearc-quest-container-repo.repository_url}:latest",
            "essential": true,
            "memoryReservation": 128
            "portMappings": [
                {
                    "containerPort": 3000,
                    "hostPort": 3000,
                    "protocol": "tcp"
                }
            ]
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.rearc-quest-task-log-group.name}"
                    "awslogs-region": "${var.aws_region}"
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ])
    execution_role_arn = aws_iam_role.rearc-quest-ecs-task-execution-role.arn
    network_mode = "awsvpc"
    cpu = 256
    memory = 512
    requires_compatibilities = ["FARGATE"]
}