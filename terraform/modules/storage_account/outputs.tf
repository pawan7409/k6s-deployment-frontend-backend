# Storage Account Module - Outputs
# File: modules/storage_account/outputs.tf
# Description: Exports storage account and container information

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.this.name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_container_id" {
  description = "The ID of the blob container"
  value       = azurerm_storage_container.container.id
}

output "storage_container_name" {
  description = "The name of the blob container"
  value       = azurerm_storage_container.container.name
}

output "storage_info" {
  description = "Complete storage account information"
  value       = local.info
}
