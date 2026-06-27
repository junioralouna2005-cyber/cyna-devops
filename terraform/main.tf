# main.tf - Infrastructure Azure CYNA
# Redacteur : Junior Alouna - DevOps

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
  location            = "Poland Central"
  resource_group_name = azurerm_resource_group.cyna.name
}

resource "azurerm_subnet" "cyna" {
  name                 = "subnet-cyna"
  resource_group_name  = azurerm_resource_group.cyna.name
  virtual_network_name = azurerm_virtual_network.cyna.name
  address_prefixes     = ["10.30.1.0/24"]
}

resource "azurerm_network_interface" "vm_test" {
  name                = "nic-vm-test-cyna"
  location            = "Poland Central"
  resource_group_name = azurerm_resource_group.cyna.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cyna.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_test" {
  name                = "vm-test-cyna"
  resource_group_name = azurerm_resource_group.cyna.name
  location            = "Poland Central"
  size = "Standard_B2ts_v2"
  admin_username      = "adminvmcyna"

  network_interface_ids = [
    azurerm_network_interface.vm_test.id,
  ]

  admin_ssh_key {
    username   = "adminvmcyna"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
