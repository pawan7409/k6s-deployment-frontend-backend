variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
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

variable "os_type" {
  description = "OS type (Linux or Windows)"
  type        = string
  default     = "Linux"
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be 'Linux' or 'Windows'."
  }
}

variable "sku_name" {
  description = "SKU name (B1, B2, B3, S1, S2, S3, P1V2, P2V2, P3V2)"
  type        = string
  default     = "B2"
}

# Backend App Service
variable "deploy_backend" {
  description = "Deploy backend App Service"
  type        = bool
  default     = true
}

variable "backend_app_name" {
  description = "Name of the backend App Service"
  type        = string
}

variable "python_version" {
  description = "Python version"
  type        = string
  default     = "3.11"
}

variable "backend_app_settings" {
  description = "App settings for backend"
  type        = map(string)
  default     = {}
}

# Frontend App Service
variable "deploy_frontend" {
  description = "Deploy frontend App Service"
  type        = bool
  default     = true
}

variable "frontend_app_name" {
  description = "Name of the frontend App Service"
  type        = string
}

variable "node_version" {
  description = "Node version"
  type        = string
  default     = "18-lts"
}

variable "frontend_app_settings" {
  description = "App settings for frontend"
  type        = map(string)
  default     = {}
}

# Application Insights
variable "app_insights_connection_string" {
  description = "Connection string for Application Insights"
  type        = string
  sensitive   = true
}

# Auto-scaling
variable "enable_autoscaling" {
  description = "Enable auto-scaling"
  type        = bool
  default     = true
}

variable "default_capacity" {
  description = "Default capacity"
  type        = number
  default     = 2
}

variable "minimum_capacity" {
  description = "Minimum capacity"
  type        = number
  default     = 1
}

variable "maximum_capacity" {
  description = "Maximum capacity"
  type        = number
  default     = 10
}

variable "cpu_threshold_increase" {
  description = "CPU threshold to trigger scale-up"
  type        = number
  default     = 70
}

variable "cpu_threshold_decrease" {
  description = "CPU threshold to trigger scale-down"
  type        = number
  default     = 30
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
