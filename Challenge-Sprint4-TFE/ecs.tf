# ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
    name                                = "challenge-sprint-ecs-cluster"
}

# Task definition
resource "aws_ecs_task_definition" "task_definition" {
    family                              = "challenge-sprint-family"
    container_definitions               = jsonencode(
    [
    {
        "name"                          : "challenge-sprint-container",
        "image"                         : "${aws_ecr_repository.ecr.repository_url}:latest",
        "entryPoint"                    : []
        "essential"                     : true,
        "networkMode"                   : "awsvpc",
        "portMappings"                  : [
                                            {
                                                "containerPort" : var.container_port,
                                                "hostPort"      : var.container_port,
                                            }
                                          ]
        "healthCheck"                   : {
                                            "command"     : [ "CMD-SHELL", "curl -f http://localhost:8081/ || exit 1" ],
                                            "interval"    : 30,
                                            "timeout"     : 5,
                                            "startPeriod" : 10,
                                            "retries"     :3
                                          }
    }
    ] 
    )
    requires_compatibilities            = ["FARGATE"]
    network_mode                        = "awsvpc"
    cpu                                 = "256"
    memory                              = "512"
    execution_role_arn                  = aws_iam_role.ecsTaskExecutionRole.arn
    task_role_arn                       = aws_iam_role.ecsTaskRole.arn
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
    name                                = "challenge-sprint-ecs-service"
    cluster                             = aws_ecs_cluster.ecs_cluster.arn
    task_definition                     = aws_ecs_task_definition.task_definition.arn
    launch_type                         = "FARGATE"
    scheduling_strategy                 = "REPLICA"
    desired_count                       = 2 # Iremos rodar com 2 nós

  network_configuration {
    subnets                             = [aws_subnet.private_subnet_1.id , aws_subnet.private_subnet_2.id]
    assign_public_ip                    = false
    security_groups                     = [aws_security_group.ecs_sg.id, aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn                    = aws_lb_target_group.target_group.arn
    container_name                      = "challenge-sprint-container"
    container_port                      = var.container_port
  }
  depends_on                            = [aws_lb_listener.listener]
}
