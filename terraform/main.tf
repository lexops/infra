terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate11649"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "lexops" {
  name     = "lexops-resources"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "lexops" {
  name                = "lexops-aks1"
  location            = azurerm_resource_group.lexops.location
  resource_group_name = azurerm_resource_group.lexops.name
  dns_prefix          = "lexopsaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.lexops.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.lexops.kube_config_raw

  sensitive = true
}