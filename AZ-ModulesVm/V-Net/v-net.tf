resource "azurerm_virtual_network" "hub-vnet" {
    name                = "${var.base_name}-vnet"
    location            = var.LOCATION
    resource_group_name = var.resource_group_name
    address_space       = ["10.2.0.0/16"]

    tags = {
    environment = "Production"
    }
}

resource "azurerm_subnet" "hub-dmz" {
    name                 = "${var.base_name}-Hub-Dmz"
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.virtual_network_name
    address_prefixes       = ["10.2.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.base_name}-Public-IP"
  resource_group_name = var.resource_group_name
  location            = var.LOCATION
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "hub-nic" {
    name                 = "${var.base_name}-Hub-Nic"
    location             = var.LOCATION
    resource_group_name  = var.resource_group_name
    enable_ip_forwarding = true

    ip_configuration {
    name                          = "az-v"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
    }

}



resource "azurerm_network_security_group" "nsg" {
  name                = "${var.base_name}-NSG"
  location            = var.LOCATION
  resource_group_name = var.resource_group_name

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
