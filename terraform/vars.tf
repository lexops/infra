variable "access_key" {
    type = string
    description = "Chave de acesso do Blob Storage onde esta o Terraform State"
}

variable "subscription_id" {
    type = string
    description = "ID da Assinatura do Azure onde sera provisionada a infra"
}

variable "tenant_id" {
    type = string
    description = "Tenant que sera usado"
}

variable "client_id" {
    type = string
    description = "ID do App Registration que o Terraform usara"
}

variable "client_secret" {
    type = string
    description = "Secret da App Registration que o Terraform usara"
}