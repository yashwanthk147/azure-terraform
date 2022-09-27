
output "Public_ip" {
  description = "public IP address of the jumpbox server"
  value       = module.v-net.Public_ip
}


output "Private_ip" {
  description = "public IP address of the jumpbox server"
  value       = module.v-net.Private_ip
}