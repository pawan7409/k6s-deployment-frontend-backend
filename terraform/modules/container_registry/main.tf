# Azure Container Registry (ACR) Module
# Purpose: Store Docker images for frontend and backend services

resource "azurerm_container_registry" "main" {
  name                = var.registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  
  # Network rules for security
  network_rule_bypass_option       = "AzureServices"
  public_network_access_enabled    = var.public_network_access_enabled
  zone_redundancy_enabled          = var.enable_zone_redundancy

  tags = merge(
    var.tags,
    {
      Name        = var.registry_name
      Environment = var.environment
    }
  )
}

# Webhooks for automation (optional)
resource "azurerm_container_registry_webhook" "main" {
  count               = var.enable_webhook ? 1 : 0
  name                = "${var.registry_name}-webhook"
  resource_group_name = var.resource_group_name
  registry_name       = azurerm_container_registry.main.name
  location            = var.location
  service_uri         = var.webhook_service_uri
  actions             = var.webhook_actions
  status              = "enabled"
  scope               = ""
}

# Replication for geo-distribution (optional)
resource "azurerm_container_registry_scope_map" "main" {
  count               = var.enable_geo_replication ? 1 : 0
  name                = "${var.registry_name}-scope-map"
  resource_group_name = var.resource_group_name
  container_registry_name = azurerm_container_registry.main.name
  actions = [
    "repositories/*/metadata/read",
    "repositories/*/metadata/write",
    "repositories/*/content/read",
    "repositories/*/content/write"
  ]
}
