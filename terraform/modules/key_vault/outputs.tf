output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the Key Vault"
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "The name of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "The URI of the Key Vault"
}

output "db_connection_string_secret_id" {
  value       = try(azurerm_key_vault_secret.db_connection_string[0].id, null)
  description = "The ID of the database connection string secret"
}

output "api_key_secret_id" {
  value       = try(azurerm_key_vault_secret.api_key[0].id, null)
  description = "The ID of the API key secret"
}

output "app_secret_id" {
  value       = try(azurerm_key_vault_secret.app_secret[0].id, null)
  description = "The ID of the app secret"
}
