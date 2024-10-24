# Criar zona hospedada no Route 53
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Criar registro A apontando para o ALB
resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_alb.application_load_balancer.dns_name  # DNS do ALB gerado
    zone_id                = aws_alb.application_load_balancer.zone_id   # Zone ID do ALB gerado
    evaluate_target_health = false
  }
}
