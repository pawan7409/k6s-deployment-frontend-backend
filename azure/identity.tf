resource "azurerm_app_service" "backend" {
  # ... existing configuration ...

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service" "frontend" {
  # ... existing configuration ...

  identity {
    type = "SystemAssigned"
  }
}
