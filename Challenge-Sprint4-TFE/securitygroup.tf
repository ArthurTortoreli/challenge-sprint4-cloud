# Security Group ECS app
resource "aws_security_group" "ecs_sg" {
    vpc_id                      = aws_vpc.vpc.id
    name                        = "challenge-sprint-sg-ecs"
    description                 = "Security group para a app ECS"
    revoke_rules_on_delete      = true
}

# ECS app Security Group Rules - INBOUND
resource "aws_security_group_rule" "ecs_alb_ingress" {
    type                        = "ingress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    description                 = "Permite inbound traffic do ALB"
    security_group_id           = aws_security_group.ecs_sg.id
    source_security_group_id    = aws_security_group.alb_sg.id
}

# ECS app Security Group Rules - OUTBOUND
resource "aws_security_group_rule" "ecs_all_egress" {
    type                        = "egress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    description                 = "Permite outbound traffic do ECS"
    security_group_id           = aws_security_group.ecs_sg.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}

# Security Group para o alb
resource "aws_security_group" "alb_sg" {
    vpc_id                      = aws_vpc.vpc.id
    name                        = "challenge-sprint-sg-alb"
    description                 = "Security group para o alb"
    revoke_rules_on_delete      = true
}

# Alb Security Group Rules - INBOUND
resource "aws_security_group_rule" "alb_http_ingress" {
    type                        = "ingress"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "TCP"
    description                 = "Permite http inbound traffic da internet"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}
resource "aws_security_group_rule" "alb_https_ingress" {
    type                        = "ingress"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "TCP"
    description                 = "Permite https inbound traffic da internet"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}

# Alb Security Group Rules - OUTBOUND
resource "aws_security_group_rule" "alb_egress" {
    type                        = "egress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    description                 = "Permite outbound traffic do alb"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}