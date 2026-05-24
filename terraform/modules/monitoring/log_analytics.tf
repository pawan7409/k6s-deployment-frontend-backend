# Azure Log Analytics Workspace Module
# Purpose: Central logging and monitoring for all resources

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = merge(
    var.tags,
    {
      Name        = var.workspace_name
      Environment = var.environment
    }
  )
}

# Log Analytics Solutions for enhanced monitoring
resource "azurerm_log_analytics_solution" "container_insights" {
  count               = var.enable_container_insights ? 1 : 0
  solution_name       = "ContainerInsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_name      = azurerm_log_analytics_workspace.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_log_analytics_solution" "key_vault_analytics" {
  count               = var.enable_key_vault_analytics ? 1 : 0
  solution_name       = "KeyVaultAnalytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_name      = azurerm_log_analytics_workspace.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/KeyVaultAnalytics"
  }
}
