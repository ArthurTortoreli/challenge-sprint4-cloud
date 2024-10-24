# ECR repo
resource "aws_ecr_repository" "ecr" {
    name                            = "challenge-sprint-repo"
}

# Policy para gerenciamento das imagens
resource "aws_ecr_lifecycle_policy" "ecr_policy" {
    repository                      = aws_ecr_repository.ecr.name
    policy                          = local.ecr_policy
}

# Definindo regras para as imagens
locals {
  ecr_policy = jsonencode({
        "rules":[
            {
                "rulePriority"      : 1,
                "description"       : "Expire images older than 14 days",
                "selection": {
                    "tagStatus"     : "any",
                    "countType"     : "sinceImagePushed",
                    "countUnit"     : "days",
                    "countNumber"   : 14
                },
                "action": {
                    "type"          : "expire"
                }
            }
        ]
    })
}

# Iremos simular um push das imagens construidas na pasta /app - ela está vazia
locals {
  docker_login_command              = "aws ecr get-login-password --region ${var.region} --profile personal| docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  docker_build_command              = "docker build -t ${aws_ecr_repository.ecr.name} ./app"
  docker_tag_command                = "docker tag ${aws_ecr_repository.ecr.name}:latest ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr.name}:latest"
  docker_push_command               = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr.name}:latest"
}

# Auth para ECR
resource "null_resource" "docker_login" {
    provisioner "local-exec" {
        command                     = local.docker_login_command
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ aws_ecr_repository.ecr ]
}

# Build a partir do Dockerfile da pasta /app - está vazia mas a ideia era ter um
resource "null_resource" "docker_build" {
    provisioner "local-exec" {
        command                     = local.docker_build_command
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_login ]
}

# Fazendo tag da imagem
resource "null_resource" "docker_tag" {
    provisioner "local-exec" {
        command                     = local.docker_tag_command
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_build ]
}

# Push da imagem para o repo
resource "null_resource" "docker_push" {
    provisioner "local-exec" {
        command                     = local.docker_push_command
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_tag ]
}
