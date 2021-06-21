resource "aws_cloudwatch_log_group" "main" {
  for_each          = var.services
  name              = each.key
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "main" {
  for_each                 = var.services
  family                   = each.key
  cpu                      = var.fargate ? each.value.cpu : null
  memory                   = var.fargate ? each.value.memory : null
  requires_compatibilities = var.fargate ? ["FARGATE"] : null
  network_mode             = var.fargate ? "awsvpc" : null
  execution_role_arn       = var.fargate ? aws_iam_role.task[0].arn : null
  container_definitions    = <<EOF
[
  {
    "name": "${each.key}",
    "image": "${each.value.image}",
    "cpu": ${each.value.cpu},
    "memory": ${each.value.memory},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-east-2",
        "awslogs-group": "${each.key}",
        "awslogs-stream-prefix": "${var.repo_name}"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "main" {
  for_each        = var.services
  name            = each.key
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main[each.key].arn
  launch_type     = var.fargate ? "FARGATE" : null
  desired_count   = each.value.desired_count

  deployment_maximum_percent         = each.value.deployment_maximum_percent
  deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent

  dynamic "ordered_placement_strategy" {
    for_each = var.fargate ? [] : [1]
    content {
      type  = "binpack"
      field = "memory"
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.fargate ? [] : [1]
    content {
      capacity_provider = aws_ecs_capacity_provider.main[0].name
      weight            = 1
    }
  }
}