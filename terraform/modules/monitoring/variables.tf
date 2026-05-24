variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "app_insights_name" {
  description = "Name of Application Insights"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku" {
  description = "SKU of the Log Analytics Workspace (PerGB2018 or Free)"
  type        = string
  default     = "PerGB2018"
  validation {
    condition     = contains(["PerGB2018", "Free"], var.sku)
    error_message = "SKU must be either 'PerGB2018' or 'Free'."
  }
}

variable "retention_in_days" {
  description = "Retention period in days (30-2555)"
  type        = number
  default     = 30
  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 2555
    error_message = "Retention days must be between 30 and 2555."
  }
}

variable "application_type" {
  description = "Type of application (web, other)"
  type        = string
  default     = "web"
  validation {
    condition     = contains(["web", "other"], var.application_type)
    error_message = "Application type must be either 'web' or 'other'."
  }
}

variable "enable_container_insights" {
  description = "Enable Container Insights solution"
  type        = bool
  default     = true
}

variable "enable_key_vault_analytics" {
  description = "Enable Key Vault Analytics solution"
  type        = bool
  default     = true
}

variable "create_alert_rules" {
  description = "Create alert rules for Application Insights"
  type        = bool
  default     = true
}

variable "action_group_id" {
  description = "Action group ID for alerts"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
