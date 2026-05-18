variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the storage account will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_tier" {
  description = "Storage tier (Standard/Premium)"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Replication type (LRS/ZRS/GRS)"
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "Name of the blob container"
  type        = string
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}

variable "create_unnecessary" {
  description = "Toggle creation of the unnecessary demonstration resource"
  type        = bool
  default     = false
}
