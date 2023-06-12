output "appgw_id" {
  description = "The ID of the Application Gateway."
  value       = module.appgw_terratest.appgw_id
}

output "appgw_name" {
  description = "The name of the Application Gateway."
  value       = module.appgw_terratest.appgw_name
}

output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = module.appgw_terratest.appgw_public_ip_address
}

output "backend_subnet_id" {
  description = "The backend subnet id"
  value       = module.test_backend_subnet.id
}

output "backend_address_pool_id" {
  description = "The backend address pool id"
  value       = module.appgw_terratest.backend_address_pool_id
}
