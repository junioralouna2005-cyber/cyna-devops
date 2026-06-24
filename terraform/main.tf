# main.tf — Infrastructure Azure CYNA
# Rédacteur : Junior Alouna — DevOps
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "cyna" {
  name     = "rg-cyna-it"
  location = "Poland Central"
}
resource "azurerm_virtual_network" "cyna" {
  name                = "vnet-cyna"
  address_space       = ["10.30.0.0/16"]
  location            = "Germany West Central"
  resource_group_name = azurerm_resource_group.cyna.name
}
