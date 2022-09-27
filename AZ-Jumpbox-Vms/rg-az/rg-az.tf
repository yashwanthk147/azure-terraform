resource "azurerm_resource_group" "terraform" {
  
  name = "${var.base_name}-RG"
  location = var.LOCATION

  tags = {
    environment = "Terraform"
  }
}

