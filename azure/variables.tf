variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "kubernetes-app-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "app_name" {
  description = "Application name prefix"
  type        = string
  default     = "kube-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "app_service_tier" {
  description = "App Service Plan tier"
  type        = string
  default     = "Standard"
}

variable "app_service_size" {
  description = "App Service Plan size"
  type        = string
  default     = "S1"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "Kubernetes-Azure"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
