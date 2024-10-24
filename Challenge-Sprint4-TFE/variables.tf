variable "region" {
  description = "Região principal para todos os recursos"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "Bloco CIDR para a VPC principal"
}

variable "public_subnet_1" {
  type        = string
  description = "Bloco CIDR para a sub-rede pública 1"
}

variable "public_subnet_2" {
  type        = string
  description = "Bloco CIDR para a sub-rede pública 2"
}

variable "private_subnet_1" {
  type        = string
  description = "Bloco CIDR para a sub-rede privada 1"
}

variable "private_subnet_2" {
  type        = string
  description = "Bloco CIDR para a sub-rede privada 2"
}

variable "availibilty_zone_1" {
  type        = string
  description = "Primeira zona de disponibilidade"
}

variable "availibilty_zone_2" {
  type        = string
  description = "Segunda zona de disponibilidade"
}

variable "default_tags" {
  type = map
  default = {
    Application = "App de Demonstração"
    Environment = "Desenvolvimento"
  }
}

variable "container_port" {
  description = "Porta que precisa ser exposta para a aplicação"
}

variable "shared_config_files" {
  description = "Caminho do seu arquivo de configuração compartilhada na pasta .aws"
}

variable "shared_credentials_files" {
  description = "Caminho do seu arquivo de credenciais compartilhadas na pasta .aws"
}

variable "credential_profile" {
  description = "Nome do perfil no seu arquivo de credenciais"
  type        = string
}

variable "record_name" {
  description = "Endereço do route53"
  type        = string
}

variable "domain_name" {
  description = "Endereço do route53"
  type        = string
}