output "app_service_plan_id" {
  value       = azurerm_service_plan.main.id
  description = "The ID of the App Service Plan"
}

output "backend_app_id" {
  value       = try(azurerm_linux_web_app.backend[0].id, null)
  description = "The ID of the backend App Service"
}

output "backend_app_name" {
  value       = try(azurerm_linux_web_app.backend[0].name, null)
  description = "The name of the backend App Service"
}

output "backend_app_default_hostname" {
  value       = try(azurerm_linux_web_app.backend[0].default_hostname, null)
  description = "The default hostname of the backend App Service"
}

output "backend_app_identity_principal_id" {
  value       = try(azurerm_linux_web_app.backend[0].identity[0].principal_id, null)
  description = "The principal ID of the backend App Service managed identity"
}

output "frontend_app_id" {
  value       = try(azurerm_linux_web_app.frontend[0].id, null)
  description = "The ID of the frontend App Service"
}

output "frontend_app_name" {
  value       = try(azurerm_linux_web_app.frontend[0].name, null)
  description = "The name of the frontend App Service"
}

output "frontend_app_default_hostname" {
  value       = try(azurerm_linux_web_app.frontend[0].default_hostname, null)
  description = "The default hostname of the frontend App Service"
}

output "frontend_app_identity_principal_id" {
  value       = try(azurerm_linux_web_app.frontend[0].identity[0].principal_id, null)
  description = "The principal ID of the frontend App Service managed identity"
}
