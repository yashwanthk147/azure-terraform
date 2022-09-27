resource "azurerm_resource_group" "terraform-group" {
  
  name = var.NAME
  location = var.LOCATION

  tags = {
    environment = "Terraform Demo"
  }
}

