resource "azurerm_resource_group" "terraform-group" {
  
  name = "${var.resource_name}-${terraform.workspace}-rg"
  location = var.zone_location

  tags = {
    environment = terraform.workspace
  }
}

