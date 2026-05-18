output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "app_service_backend_hostname" {
  description = "Hostname of the backend App Service"
  value       = azurerm_app_service.backend.default_site_hostname
}

output "app_service_frontend_hostname" {
  description = "Hostname of the frontend App Service"
  value       = azurerm_app_service.frontend.default_site_hostname
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of storage account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = azurerm_function_app.function_app.name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = azurerm_function_app.function_app.default_hostname
}

output "container_registry_login_server" {
  description = "Login server of the container registry"
  value       = azurerm_container_registry.acr.login_server
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.appinsights.instrumentation_key
  sensitive   = true
}
