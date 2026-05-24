output "function_app_id" {
  value       = azurerm_linux_function_app.main.id
  description = "The ID of the Function App"
}

output "function_app_name" {
  value       = azurerm_linux_function_app.main.name
  description = "The name of the Function App"
}

output "function_app_default_hostname" {
  value       = azurerm_linux_function_app.main.default_hostname
  description = "The default hostname of the Function App"
}

output "function_app_identity_principal_id" {
  value       = azurerm_linux_function_app.main.identity[0].principal_id
  description = "The principal ID of the Function App managed identity"
}

output "function_app_plan_id" {
  value       = azurerm_service_plan.function.id
  description = "The ID of the Function App Service Plan"
}

output "staging_slot_id" {
  value       = try(azurerm_linux_function_app_slot.staging[0].id, null)
  description = "The ID of the staging deployment slot"
}

output "staging_slot_default_hostname" {
  value       = try(azurerm_linux_function_app_slot.staging[0].default_hostname, null)
  description = "The default hostname of the staging slot"
}
