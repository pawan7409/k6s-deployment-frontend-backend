# Azure Key Vault Module
# Purpose: Secure storage for secrets, certificates, and keys

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  enabled_for_deployment      = true
  purge_protection_enabled    = var.enable_purge_protection
  soft_delete_retention_days  = var.soft_delete_retention_days
  network_rule_bypass_option = "AzureServices"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
    ]
  }

  tags = merge(
    var.tags,
    {
      Name        = var.key_vault_name
      Environment = var.environment
    }
  )

  depends_on = [var.resource_group_id]
}

# Key Vault Secrets for Application
resource "azurerm_key_vault_secret" "db_connection_string" {
  count           = var.create_sample_secrets ? 1 : 0
  name            = "db-connection-string"
  value           = var.db_connection_string
  key_vault_id    = azurerm_key_vault.main.id
  expiration_date = var.secret_expiration_date
}

resource "azurerm_key_vault_secret" "api_key" {
  count           = var.create_sample_secrets ? 1 : 0
  name            = "api-key"
  value           = var.api_key
  key_vault_id    = azurerm_key_vault.main.id
  expiration_date = var.secret_expiration_date
}

resource "azurerm_key_vault_secret" "app_secret" {
  count           = var.create_sample_secrets ? 1 : 0
  name            = "app-secret"
  value           = var.app_secret
  key_vault_id    = azurerm_key_vault.main.id
  expiration_date = var.secret_expiration_date
}
