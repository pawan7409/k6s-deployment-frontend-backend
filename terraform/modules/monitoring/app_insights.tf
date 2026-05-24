# Azure Application Insights Module
# Purpose: Monitor application performance and diagnose issues

resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
  workspace_id        = azurerm_log_analytics_workspace.main.id

  tags = merge(
    var.tags,
    {
      Name        = var.app_insights_name
      Environment = var.environment
    }
  )
}

# Application Insights Alert Rule for high error rate
resource "azurerm_monitor_metric_alert" "high_error_rate" {
  count               = var.create_alert_rules ? 1 : 0
  name                = "${var.app_insights_name}-high-error-rate"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when error rate is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_name      = "server/exceptions"
    metric_namespace = "Microsoft.Insights/components"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = var.action_group_id
  }
}

# Application Insights Alert Rule for high response time
resource "azurerm_monitor_metric_alert" "high_response_time" {
  count               = var.create_alert_rules ? 1 : 0
  name                = "${var.app_insights_name}-high-response-time"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when response time is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_name      = "request/duration"
    metric_namespace = "Microsoft.Insights/components"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5000
  }

  action {
    action_group_id = var.action_group_id
  }
}
