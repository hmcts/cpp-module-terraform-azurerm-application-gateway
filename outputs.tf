output "appgw_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.app_gateway.id
}

output "appgw_name" {
  description = "The name of the Application Gateway."
  value       = "${module.tag_set.id}-appgw"
}

output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = azurerm_public_ip.pip1.ip_address
}

output "backend_subnet_id" {
  description = "The backend subnet id"
  value       = azurerm_subnet.backend.id
}

output "backend_address_pool_id" {
  description = "The backend address pool id"
  value       = azurerm_application_gateway.app_gateway.backend_address_pool[0].id
}
