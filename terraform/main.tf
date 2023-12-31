terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate20646"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
      access_key           = var.access_key
  }

}

provider "azurerm" {
  features {}

  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
  client_id         = var.client_id
  client_secret     = var.client_secret 
}

resource "azurerm_resource_group" "lexops-rg" {
  name     = "lexops-rg"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "lexops-aks" {
  name                = "lexops-aks"
  location            = azurerm_resource_group.lexops-rg.location
  resource_group_name = azurerm_resource_group.lexops-rg.name
  dns_prefix          = "lexops"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure-cni"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Dev"
  }

  depends_on = [
    azurerm_resource_group.lexops-rg,
  ]
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}