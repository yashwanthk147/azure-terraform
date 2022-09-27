output "v-out" {
    value = azurerm_virtual_network.hub-vnet.name
  
}

output "sub-out" {
    value = azurerm_subnet.hub-dmz.id
  
}

#output "public_ip_add_id" {
#    value = azurerm_public_ip.public_ip.id
  
#}

output "VMS-NIC" {
  value = azurerm_network_interface.hub-nic.id
  
}

output "VMS-Jump-Nic" {
    value = azurerm_network_interface.jumpbox-nic.id
  
}

output "Public_ip" {
  description = "public IP address of the jumpbox server"
  value       = azurerm_public_ip.jump-pub-ip.ip_address
}

output "Private_ip" {
  description = "private IP address of the jumpbox server"
  value       = azurerm_network_interface.hub-nic.private_ip_address
}