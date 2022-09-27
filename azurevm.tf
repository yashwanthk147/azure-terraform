# Configure the Microsoft Azure Provider
terraform {
required_version = ">= 1.2.9"
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = ">= 2.0.0, < 2.60.0"
#version = ">= 2.0"
}
}
}
provider "azurerm" {
subscription_id = var.subscription_id
client_id = var.client_id
client_secret = var.client_secret
tenant_id = var.tenant_id
features {}

}
resource "azurerm_resource_group" "terraform-group" {
  
  name = "Terraform-groups-1"
  location = "eastus"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_network" "hub-vnet" {
    name                = "v-az-vnet"
    location            = azurerm_resource_group.terraform-group.location
    resource_group_name = azurerm_resource_group.terraform-group.name
    address_space       = ["10.2.0.0/16"]

    tags = {
    environment = "Production"
    }
}

resource "azurerm_subnet" "hub-mgmt" {
    name                 = "web-subnet"
    resource_group_name  = azurerm_resource_group.terraform-group.name
    virtual_network_name = azurerm_virtual_network.hub-vnet.name
    address_prefixes       = ["10.2.0.0/24"]
}

resource "azurerm_subnet" "hub-dmz" {
    name                 = "dmz-subnet"
    resource_group_name  = azurerm_resource_group.terraform-group.name
    virtual_network_name = azurerm_virtual_network.hub-vnet.name
    address_prefixes       = ["10.2.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm-pubip"
  resource_group_name = azurerm_resource_group.terraform-group.name
  location            = azurerm_resource_group.terraform-group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "hub-nic" {
    name                 = "az-v-nic"
    location             = azurerm_resource_group.terraform-group.location
    resource_group_name  = azurerm_resource_group.terraform-group.name
    enable_ip_forwarding = true

    ip_configuration {
    name                          = "az-v"
    subnet_id                     = azurerm_subnet.hub-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    }

}

resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = azurerm_resource_group.terraform-group.location
  resource_group_name = azurerm_resource_group.terraform-group.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "web-eus-vm"
  location              = azurerm_resource_group.terraform-group.location
  resource_group_name   = azurerm_resource_group.terraform-group.name
  network_interface_ids = [azurerm_network_interface.hub-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


output "public_ip" {
  description = "public IP address of the jumpbox server"
  value       = azurerm_public_ip.public_ip.ip_address
}