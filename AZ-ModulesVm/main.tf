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

module "rg-az" {
    source = "./rg-az"
    LOCATION = "eastus"
    base_name = "Terraform-groups-sg"

  
}

module "v-net" {
    source = "./V-Net"
    LOCATION = "eastus"
    base_name = "Terraform-groups-sg"
    resource_group_name = module.rg-az.rg_out
    virtual_network_name = module.v-net.v-out
    subnet_id = module.v-net.sub-out
    public_ip_address_id = module.v-net.public_ip_add_id
}

module "vms" {
    source = "./Vms"
    LOCATION = "eastus"
    base_name = "Terraform-groups-sg"
    resource_group_name = module.rg-az.rg_out
    VMS-NIC = module.v-net.VMS-NIC
    vm_id = module.vms.vm_id
    user_id = "testadmin"
    passd = "Password1234!"

  
}
