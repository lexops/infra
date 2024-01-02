terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
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

  depends_on = [
    azurerm_resource_group.lexops
  ]
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.lexops.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.lexops.kube_config_raw

  sensitive = true
}

output "cluster_endpoint" {
  value = azurerm_kubernetes_cluster.lexops.
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.lexops.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.lexops.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.lexops.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.lexops.kube_config.0.cluster_ca_certificate)

  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  depends_on = [
    azurerm_kubernetes_cluster.lexops
  ]
}