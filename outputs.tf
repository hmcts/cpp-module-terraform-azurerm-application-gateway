output "appgw_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.app_gateway.id
}

output "appgw_name" {
  description = "The name of the Application Gateway."
  value       = azurerm_application_gateway.app_gateway.name
}

output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = var.frontend_type == "public" ? var.frontend_public_ip_address.ip_address : null
}

output "backend_address_pool_id" {
  description = "The backend address pool id"
  value       = azurerm_application_gateway.app_gateway.backend_address_pool.*.id
}


output "debug_backend_address_pools" {
  value = var.backend_address_pools
}
