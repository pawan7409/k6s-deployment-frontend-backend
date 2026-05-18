terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.app_name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = var.app_service_tier
    size = var.app_service_size
  }

  tags = var.tags
}

# App Service for Backend
resource "azurerm_app_service" "backend" {
  name                = "${var.app_name}-backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    always_on = true
    http2_enabled = true
    
    app_command_line = "python -m flask run --host=0.0.0.0"

    linux_fx_version = "PYTHON|3.11"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "ENVIRONMENT"                          = var.environment
    "STORAGE_ACCOUNT_NAME"                = azurerm_storage_account.storage.name
    "KEYVAULT_URL"                        = azurerm_key_vault.kv.vault_uri
  }

  tags = var.tags
}

# App Service for Frontend
resource "azurerm_app_service" "frontend" {
  name                = "${var.app_name}-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    always_on = true
    http2_enabled = true
    linux_fx_version = "NODE|18-lts"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "BACKEND_API_URL"                     = "https://${azurerm_app_service.backend.default_site_hostname}"
  }

  tags = var.tags
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = replace("${var.app_name}stor", "-", "")
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                = replace("${var.app_name}-kv", "-", "")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = false

  tags = var.tags
}

# Key Vault Access Policy for Backend App Service
resource "azurerm_key_vault_access_policy" "backend" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.backend.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# Function App Storage Account
resource "azurerm_storage_account" "function_storage" {
  name                     = replace("${var.app_name}func", "-", "")
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Function App Service Plan
resource "azurerm_app_service_plan" "function_plan" {
  name                = "${var.app_name}-func-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = var.tags
}

# Azure Function App
resource "azurerm_function_app" "function_app" {
  name                       = "${var.app_name}-func"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  runtime_version            = "~4"

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "ENVIRONMENT"              = var.environment
  }

  tags = var.tags
}

# Container Registry for Docker images
resource "azurerm_container_registry" "acr" {
  name                = replace("${var.app_name}acr", "-", "")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  admin_enabled       = true

  tags = var.tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "${var.app_name}-log-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"

  tags = var.tags
}

# Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.app_name}-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_workspace.id

  tags = var.tags
}

# Data source to get current Azure context
data "azurerm_client_config" "current" {}
