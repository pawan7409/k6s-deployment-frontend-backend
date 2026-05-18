variable "environment" {
  type        = string
  description = "Environment name"
}

variable "azure_region" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "project_name" {
  type        = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_tier" {
  type    = string
  default = "Standard"
}

variable "storage_replication_type" {
  type    = string
  default = "LRS"
}

variable "container_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_unnecessary" {
  type    = bool
  default = false
}

variable "lookup_existing_account" {
  type    = bool
  default = false
}

# PCAM Networking Variables
variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the Virtual Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the application subnet"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for the application subnet"
}

variable "aks_subnet_name" {
  type        = string
  description = "Name of the AKS subnet"
}

variable "aks_subnet_address_prefix" {
  type        = string
  description = "Address prefix for the AKS subnet"
}

variable "create_nsg" {
  type        = bool
  description = "Whether to create a Network Security Group"
  default     = true
}

variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group"
  default     = "nsg-k8s-app"
}

variable "create_route_table" {
  type        = bool
  description = "Whether to create a route table"
  default     = true
}

variable "route_table_name" {
  type        = string
  description = "Name of the route table"
  default     = "rt-k8s-app"
}

variable "create_public_ip" {
  type        = bool
  description = "Whether to create a public IP address"
  default     = false
}

variable "public_ip_name" {
  type        = string
  description = "Name of the public IP address"
  default     = "pip-k8s-app"
}

variable "create_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT Gateway"
  default     = false
}

variable "nat_gateway_name" {
  type        = string
  description = "Name of the NAT Gateway"
  default     = "natgw-k8s-app"
}

variable "create_app_gateway" {
  type        = bool
  description = "Whether to create an Application Gateway"
  default     = false
}

variable "app_gateway_name" {
  type        = string
  description = "Name of the Application Gateway"
  default     = "appgw-k8s-app"
}

variable "create_private_dns_zone" {
  type        = bool
  description = "Whether to create a private DNS zone"
  default     = false
}
