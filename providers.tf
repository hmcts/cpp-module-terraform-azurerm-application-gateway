terraform {

  required_version = ">=0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "8cdb5405-7535-4349-92e9-f52bddc7833a"
  features {}
}
