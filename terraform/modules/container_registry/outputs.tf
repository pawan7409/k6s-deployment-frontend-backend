output "registry_id" {
  value       = azurerm_container_registry.main.id
  description = "The ID of the Container Registry"
}

output "registry_name" {
  value       = azurerm_container_registry.main.name
  description = "The name of the Container Registry"
}

output "registry_login_server" {
  value       = azurerm_container_registry.main.login_server
  description = "The login server URL for the Container Registry"
}

output "admin_username" {
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
  description = "Admin username for Container Registry"
}

output "admin_password" {
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
  description = "Admin password for Container Registry"
}

output "registry_fqdn" {
  value       = azurerm_container_registry.main.login_server
  description = "FQDN of the Container Registry"
}
