# Azure Function App Module
# Purpose: Process background tasks and scheduled jobs

resource "azurerm_service_plan" "function" {
  name                = var.function_app_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.function_app_sku

  tags = merge(
    var.tags,
    {
      Name        = var.function_app_plan_name
      Environment = var.environment
    }
  )
}

# Function App
resource "azurerm_linux_function_app" "main" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function.id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    application_stack {
      python_version = var.python_version
    }

    cors {
      allowed_origins = var.cors_allowed_origins
    }

    minimum_tls_version = "1.2"
  }

  app_settings = merge(
    var.function_app_settings,
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.app_insights_connection_string
      "ApplicationInsightsAgent_EXTENSION_VERSION"  = "~4"
      "ENABLE_INIT_LOGGING"                        = "true"
      "FUNCTIONS_WORKER_PROCESS_COUNT"             = "2"
      "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    }
  )

  tags = merge(
    var.tags,
    {
      Name = var.function_app_name
      Type = "Function"
    }
  )

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_service_plan.function
  ]
}

# Function App Slot for staging (optional)
resource "azurerm_linux_function_app_slot" "staging" {
  count           = var.create_staging_slot ? 1 : 0
  name            = "staging"
  function_app_id = azurerm_linux_function_app.main.id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key

  site_config {
    application_stack {
      python_version = var.python_version
    }

    cors {
      allowed_origins = var.cors_allowed_origins
    }

    minimum_tls_version = "1.2"
  }

  app_settings = merge(
    var.function_app_settings,
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.app_insights_connection_string
      "ApplicationInsightsAgent_EXTENSION_VERSION"  = "~4"
      "ENVIRONMENT"                                = "staging"
    }
  )

  tags = merge(
    var.tags,
    {
      Name = "${var.function_app_name}-staging"
      Slot = "staging"
    }
  )
}

# Function App Auto-scaling
resource "azurerm_monitor_autoscale_setting" "function" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "${var.function_app_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.function.id

  profile {
    name = "default"

    capacity {
      default = var.default_capacity
      minimum = var.minimum_capacity
      maximum = var.maximum_capacity
    }

    rule {
      metric_trigger {
        metric_name        = "PercentageCpu"
        metric_resource_id = azurerm_service_plan.function.id
        time_grain         = "PT1M"
        time_aggregation   = "Average"
        statistic          = "Average"
        time_window        = "PT5M"
        operator           = "GreaterThan"
        threshold          = var.cpu_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }
}
