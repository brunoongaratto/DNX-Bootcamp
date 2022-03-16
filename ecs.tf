# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "Final-challenge-cluster"
}

# Create ECS task definition
resource "aws_ecs_task_definition" "task_definition" {
  family             = "worker"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "worker",
      image     = "", #image
      cpu       = 10
      memory    = 512
      essential = true
      environment = [
        {
          "name" : "APP_NAME",
          "value" : "Laravel"
        },
        {
          "name" : "APP_ENV",
          "value" : "local"
        },
        {
          "name" : "APP_KEY",
          "value" : "base64:+/FQNhtSP2dDuCuQReSF3pcz1ztJi29qchU7zThGA8c="
        },
        {
          "name" : "APP_DEBUG",
          "value" : "true"
        },
        {
          "name" : "APP_LOG_LEVEL",
          "value" : "debug"
        },
        {
          "name" : "APP_URL",
          "value" : "http://localhost"
        },
        {
          "name" : "DB_CONNECTION",
          "value" : "mysql"
        },
        {
          "name" : "DB_HOST",
          "value" : "terraform-20220316031006412800000003.c2um9xuvwycx.ap-southeast-2.rds.amazonaws.com" #RDS endpoint
        },
        {
          "name" : "DB_PORT",
          "value" : "3306"
        },
        {
          "name" : "DB_DATABASE",
          "value" : "mydb"
        },
        {
          "name" : "DB_USERNAME",
          "value" : "user1"
        },
        {
          "name" : "DB_PASSWORD",
          "value" : "password"
        },
        {
          "name" : "BROADCAST_DRIVER",
          "value" : "log"
        },
        {
          "name" : "CACHE_DRIVER",
          "value" : "file"
        },
        {
          "name" : "SESSION_DRIVER",
          "value" : "file"
        },
        {
          "name" : "QUEUE_DRIVER",
          "value" : "sync"
        },
        {
          "name" : "CORS_ALLOWED_ORIGINS",
          "value" : "http://localhost:3000,http://localhost:4200"
        },
      ]
      portMappings = [{
        protocol      = "tcp"
        containerPort = 80
        hostPort      = 80
      }]
    }
  ])
}

# Create ECS service
resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = aws_lb_target_group.final-challenge-target-group.arn
    container_name   = "worker"
    container_port   = 80
  }
}


