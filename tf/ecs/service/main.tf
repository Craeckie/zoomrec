resource "aws_cloudwatch_log_group" "zoomrec" {
  name              = "zoomrec"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "zoomrec" {
  family = "zoomrec"

  volume {
    name      = "efs"
    host_path = "/mnt/efs"
  }

  container_definitions = <<EOF
[
  {
    "name": "zoomrec",
    "image": "kastldratza/zoomrec:latest",
    "cpu": 128,
    "memory": 256,
    "mountPoints": [
      {
        "containerPath": "/mnt/efs",
        "sourceVolume": "efs"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "eu-west-1",
        "awslogs-group": "zoomrec",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

/*resource "aws_ecs_service" "zoomrec" {
  name            = "zoomrec"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.zoomrec.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}*/
