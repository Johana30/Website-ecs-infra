data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.iam-role-name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.Cluster-name
}

resource "aws_ecs_service" "example" {
  name            = var.family-name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = var.desired_count
  launch_type     = var.ecs-type

  network_configuration {
    subnets          = [for subnet in var.subnets : subnet]

    security_groups  = [var.scg-ecs]
    assign_public_ip = true
  }
  //force_new_deployment = true
  load_balancer {
    target_group_arn = var.alb-arn
    container_name   = var.container-name
    container_port   = 80
  }

  depends_on = [aws_ecs_task_definition.task-definition]
}

//task definition
resource "aws_ecs_task_definition" "task-definition" {
  family                   = var.family-name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  cpu                = var.cpu
  memory             = var.memory
  container_definitions = var.file
  runtime_platform {
    operating_system_family = var.OS
    cpu_architecture = "ARM64"
  }
}
