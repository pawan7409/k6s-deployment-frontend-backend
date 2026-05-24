variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "function_app_plan_name" {
  description = "Name of the Function App Service Plan"
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

variable "function_app_sku" {
  description = "SKU for Function App (Y1, EP1, EP2, EP3, ASP1, ASP2, ASP3)"
  type        = string
  default     = "Y1"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key for the storage account"
  type        = string
  sensitive   = true
}

variable "python_version" {
  description = "Python version (3.9, 3.10, 3.11)"
  type        = string
  default     = "3.11"
  validation {
    condition     = contains(["3.9", "3.10", "3.11"], var.python_version)
    error_message = "Python version must be 3.9, 3.10, or 3.11."
  }
}

variable "cors_allowed_origins" {
  description = "CORS allowed origins"
  type        = list(string)
  default     = ["*"]
}

variable "app_insights_connection_string" {
  description = "Connection string for Application Insights"
  type        = string
  sensitive   = true
}

variable "function_app_settings" {
  description = "App settings for Function App"
  type        = map(string)
  default     = {}
}

variable "create_staging_slot" {
  description = "Create a staging deployment slot"
  type        = bool
  default     = true
}

variable "enable_autoscaling" {
  description = "Enable auto-scaling"
  type        = bool
  default     = true
}

variable "default_capacity" {
  description = "Default instance count"
  type        = number
  default     = 1
}

variable "minimum_capacity" {
  description = "Minimum instance count"
  type        = number
  default     = 1
}

variable "maximum_capacity" {
  description = "Maximum instance count"
  type        = number
  default     = 10
}

variable "cpu_threshold" {
  description = "CPU percentage threshold for scaling"
  type        = number
  default     = 70
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
