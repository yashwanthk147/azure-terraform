output "v-out" {
    value = azurerm_virtual_network.hub-vnet.name
  
}

output "sub-out" {
    value = azurerm_subnet.hub-dmz.id
  
}

output "public_ip_add_id" {
    value = azurerm_public_ip.public_ip.id
  
}

output "VMS-NIC" {
  value = azurerm_network_interface.hub-nic.id
  
}

