# Resource Group Module - Outputs
# File: modules/resource_group/outputs.tf
# Description: Exports resource group information for use in other modules

output "resource_group_id" {
  description = "The ID of the created Resource Group"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "The name of the created Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "The location of the created Resource Group"
  value       = azurerm_resource_group.rg.location
}

output "resource_group_info" {
  description = "Complete Resource Group information"
  value       = local.resource_group_info
}
