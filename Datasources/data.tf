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

data "azurerm_resources" "example" {
  resource_group_name = "Terraform-groups-2"
}