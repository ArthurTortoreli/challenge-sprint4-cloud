#  Application Load Balancer
resource "aws_alb" "application_load_balancer" {
  name                      = "challenge-sprint-alb"
  internal                  = false
  load_balancer_type        = "application"
  subnets                   = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups           = [aws_security_group.alb_sg.id]
}

# Target group e health check
resource "aws_lb_target_group" "target_group" {
  name                      = "challenge-sprint-tg"
  port                      = var.container_port
  protocol                  = "HTTP"
  target_type               = "ip"
  vpc_id                    = aws_vpc.vpc.id
  health_check {
      path                  = "/health"
      protocol              = "HTTP"
      matcher               = "200"
      port                  = "traffic-port"
      healthy_threshold     = 2
      unhealthy_threshold   = 2
      timeout               = 10
      interval              = 30
  }
}

# HTTP Listener para o ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn         = aws_alb.application_load_balancer.arn
  port                      = "80"
  protocol                  = "HTTP"
  default_action {
    type                    = "forward"
    target_group_arn        = aws_lb_target_group.target_group.arn
  }
}