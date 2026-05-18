# Resource Group Module - Variables
# File: modules/resource_group/variables.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.resource_group_name))
    error_message = "Resource group name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  validation {
    condition     = contains(["eastus", "westus", "northeurope", "westeurope", "southeastasia"], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
