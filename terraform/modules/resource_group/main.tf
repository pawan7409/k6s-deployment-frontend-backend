# Resource Group Module - Main Configuration
# File: modules/resource_group/main.tf
# Description: Creates Azure Resource Group with proper tagging and naming conventions

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      CreatedDate = timestamp()
    }
  )

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]
  }
}

# Data block to reference other resource groups if needed
data "azurerm_resource_groups" "example" {
  depends_on = [azurerm_resource_group.rg]
}

# Local value for resource group info
locals {
  resource_group_info = {
    id       = azurerm_resource_group.rg.id
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
}
