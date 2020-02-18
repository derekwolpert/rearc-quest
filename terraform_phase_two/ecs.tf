# Creates ECS cluster to run the project's Docker image on.

resource "aws_ecs_cluster" "rearc-quest-ecs-cluster" {
  name = "rearc-quest-ecs-cluster"
}

# Creates a log group when task are ran within the ECS cluster. This can be helpful
# for debugging purposes if a unexpected issue arises.

resource "aws_cloudwatch_log_group" "rearc-quest-task-log-group" {
  name = "rearc-quest-task-log-group"
}

# The Data block below allows information about the ECR repository created in phase one
# to be accessiable within phase two - in this case, passing the correct Docker image
# into the container and task definitions below.

data "aws_ecr_repository" "rearc-quest-container-repo" {
  name = "rearc-quest-container-repo"
}

# The task and container definitions below are given the ECS cluster to offer instructions 
# on how to deploy the Docker container used in this project.

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

# The ECS Service makes it possible to specifiy the given tasks to launch on the ECS
# Cluster, and configure related attributes like the network and load balancer environments. 

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

# Basic application autoscaling resource, since there will never be more than one
# task running in this ECS cluster configuration. If there were more tasks running,
# you could impliment autoscaling policies to monitor and control memory and cpu
# allocation - or you could set different resource allocation based on time of day.

resource "aws_appautoscaling_target" "reacr-quest-autoscalling" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.rearc-quest-ecs-cluster.name}/${aws_ecs_service.rearc-quest-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn = aws_iam_role.rearc-quest-ecs-autoscaling-role.arn
  min_capacity       = 1
  max_capacity       = 1
}