terraform {
  required_version = ">1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {

  }
}
