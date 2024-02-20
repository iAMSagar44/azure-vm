# Define the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# Define the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Define the subnets for each VM
resource "azurerm_subnet" "subnet" {
  count                = var.vm_count
  name                 = "example-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
}

# Define the network interface for each VM
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "example-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "example-ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the virtual machine for each VM
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "example-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_A1_v2"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]
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

  # Define the administrator username and password
  admin_username                  = "adminuser"
  admin_password                  = var.vm_pwd
  disable_password_authentication = false
}
