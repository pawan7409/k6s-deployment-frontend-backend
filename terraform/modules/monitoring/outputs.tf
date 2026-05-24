output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "The ID of the Log Analytics Workspace"
}

output "log_analytics_workspace_name" {
  value       = azurerm_log_analytics_workspace.main.name
  description = "The name of the Log Analytics Workspace"
}

output "app_insights_id" {
  value       = azurerm_application_insights.main.id
  description = "The ID of Application Insights"
}

output "app_insights_instrumentation_key" {
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
  description = "The instrumentation key for Application Insights"
}

output "app_insights_connection_string" {
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
  description = "The connection string for Application Insights"
}

output "app_insights_app_id" {
  value       = azurerm_application_insights.main.app_id
  description = "The App ID of Application Insights"
}
