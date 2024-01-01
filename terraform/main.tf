variable "client_secret" {
    type = string
}

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

  client_id       = "4a602e59-1740-4a2f-b5e1-4e4f7e7f5b76"
  client_secret   = var.client_secret
  tenant_id       = "3c4b970b-3baf-414d-9c48-f4156b6699a7"
  subscription_id = "5dfa2801-0f54-495f-9cf4-43526363870d"
}

/*
resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "eastus"
}
*/