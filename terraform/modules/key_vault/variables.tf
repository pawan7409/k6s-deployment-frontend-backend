variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the principal (user or service principal)"
  type        = string
}

variable "sku_name" {
  description = "The Name of the SKU (standard or premium)"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU name must be either 'standard' or 'premium'."
  }
}

variable "enable_purge_protection" {
  description = "Enable purge protection"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days (7-90)"
  type        = number
  default     = 7
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "default_action" {
  description = "Default action for network rules (Allow or Deny)"
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["Allow", "Deny"], var.default_action)
    error_message = "Default action must be either 'Allow' or 'Deny'."
  }
}

variable "create_sample_secrets" {
  description = "Create sample secrets"
  type        = bool
  default     = false
}

variable "db_connection_string" {
  description = "Database connection string"
  type        = string
  sensitive   = true
  default     = ""
}

variable "api_key" {
  description = "API key secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "app_secret" {
  description = "Application secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "secret_expiration_date" {
  description = "Expiration date of secrets (Unix timestamp)"
  type        = number
  default     = null
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
