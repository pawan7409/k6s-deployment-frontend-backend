// Storage Account module - creates a storage account and a container
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type

  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  name                     = var.container_name
  storage_account_id       = azurerm_storage_account.this.id
  container_access_type    = "private"
}

// An explicit "unnecessary" resource to demonstrate conditional/unused blocks.
// It is controlled by the variable `create_unnecessary` and defaults to false.
resource "null_resource" "unnecessary" {
  count = var.create_unnecessary ? 1 : 0

  triggers = {
    reason = "This resource is intentionally unnecessary and usually not created"
  }

  lifecycle {
    prevent_destroy = false
  }
}

locals {
  info = {
    id   = azurerm_storage_account.this.id
    name = azurerm_storage_account.this.name
  }
}
