# Azure App Service Module
# Purpose: Deploy backend and frontend applications

resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = merge(
    var.tags,
    {
      Name        = var.app_service_plan_name
      Environment = var.environment
    }
  )
}

# App Service for Backend
resource "azurerm_linux_web_app" "backend" {
  count               = var.deploy_backend ? 1 : 0
  name                = var.backend_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      python_version = var.python_version
    }

    minimum_tls_version      = "1.2"
    http2_enabled            = true
    websockets_enabled       = true
    use_32_bit_worker        = false
    managed_pipeline_mode    = "Integrated"
    health_check_path        = "/health"
  }

  app_settings = merge(
    var.backend_app_settings,
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.app_insights_connection_string
      "ApplicationInsightsAgent_EXTENSION_VERSION"  = "~3"
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE"        = "false"
      "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    }
  )

  tags = merge(
    var.tags,
    {
      Name = var.backend_app_name
      Tier = "backend"
    }
  )

  identity {
    type = "SystemAssigned"
  }
}

# App Service for Frontend
resource "azurerm_linux_web_app" "frontend" {
  count               = var.deploy_frontend ? 1 : 0
  name                = var.frontend_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = var.node_version
    }

    minimum_tls_version      = "1.2"
    http2_enabled            = true
    websockets_enabled       = true
    use_32_bit_worker        = false
    health_check_path        = "/"
  }

  app_settings = merge(
    var.frontend_app_settings,
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.app_insights_connection_string
      "ApplicationInsightsAgent_EXTENSION_VERSION"  = "~3"
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE"        = "false"
      "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    }
  )

  tags = merge(
    var.tags,
    {
      Name = var.frontend_app_name
      Tier = "frontend"
    }
  )

  identity {
    type = "SystemAssigned"
  }
}

# Auto-scaling for App Service Plan
resource "azurerm_monitor_autoscale_setting" "app_service" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "${var.app_service_plan_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.main.id

  profile {
    name = "default"

    capacity {
      default = var.default_capacity
      minimum = var.minimum_capacity
      maximum = var.maximum_capacity
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.main.id
        time_grain         = "PT1M"
        time_aggregation   = "Average"
        statistic          = "Average"
        time_window        = "PT5M"
        operator           = "GreaterThan"
        threshold          = var.cpu_threshold_increase
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.main.id
        time_grain         = "PT1M"
        time_aggregation   = "Average"
        statistic          = "Average"
        time_window        = "PT5M"
        operator           = "LessThan"
        threshold          = var.cpu_threshold_decrease
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }
}
