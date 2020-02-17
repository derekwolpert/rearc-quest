resource "aws_ecs_cluster" "rearc-quest-ecs-cluster" {
  name = "rearc-quest-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "rearc-quest-task-log-group" {
  name = "rearc-quest-task-log-group"
}

data "aws_ecr_repository" "rearc-quest-container-repo" {
  name = "rearc-quest-container-repo"
}

resource "aws_ecs_task_definition" "rearc-quest-task-definition" {
    family = "rearc-quest-task-definition"
    container_definitions = jsonencode([
        {
            "name": "rearc-quest-container-definition",
            "image": "${data.aws_ecr_repository.rearc-quest-container-repo.repository_url}:latest",
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

resource "aws_ecs_service" "rearc-quest-ecs-service" {
  name = "rearc-quest-ecs-service"
  cluster = aws_ecs_cluster.rearc-quest-ecs-cluster.id
  task_definition = aws_ecs_task_definition.rearc-quest-task-definition.id
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.rearc-quest-ecs-security-group.id]
    subnets = [aws_subnet.rearc-quest-subnet-1.id, aws_subnet.rearc-quest-subnet-2.id, aws_subnet.rearc-quest-subnet-3.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.rearc-quest-target-group.id
    container_name = "rearc-quest-container-definition"
    container_port = "3000"
  }
}