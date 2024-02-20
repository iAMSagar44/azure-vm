terraform {
  required_version = ">1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.72.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
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
