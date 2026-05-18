# PCAM Networking Module - Variables
# File: PCAM/variables.tf
# Description: All networking parameters for PCAM (Unified Networking Configuration)

# Core Networking Variables
variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.vnet_name))
    error_message = "VNet name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "VNet address space must not be empty."
  }
}

variable "location" {
  description = "Azure region for networking resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Subnet Configuration
variable "subnet_name" {
  description = "Name of the application subnet"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for the application subnet"
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = string
}

# Network Security Group (NSG) Configuration
variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "nsg-k8s-app"
}

variable "create_nsg" {
  description = "Whether to create a Network Security Group"
  type        = bool
  default     = true
}

variable "nsg_rules" {
  description = "Network Security Group rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "AllowHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowHTTPS"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# Route Table Configuration
variable "create_route_table" {
  description = "Whether to create a route table"
  type        = bool
  default     = true
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "rt-k8s-app"
}

variable "routes" {
  description = "Route table routes"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = [
    {
      name           = "default_internet"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

# Network Interface Configuration
variable "create_nic" {
  description = "Whether to create a network interface"
  type        = bool
  default     = false
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "nic-k8s-app"
}

variable "nic_ip_configuration_name" {
  description = "Name of the NIC IP configuration"
  type        = string
  default     = "ipconfig1"
}

variable "nic_ip_address_allocation" {
  description = "IP address allocation method (Static/Dynamic)"
  type        = string
  default     = "Dynamic"
  validation {
    condition     = contains(["Static", "Dynamic"], var.nic_ip_address_allocation)
    error_message = "IP address allocation must be Static or Dynamic."
  }
}

variable "private_ip_address" {
  description = "Private IP address for NIC (required if allocation is Static)"
  type        = string
  default     = null
}

# Public IP Configuration
variable "create_public_ip" {
  description = "Whether to create a public IP address"
  type        = bool
  default     = false
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = "pip-k8s-app"
}

variable "public_ip_allocation_method" {
  description = "Public IP allocation method (Static/Dynamic)"
  type        = string
  default     = "Static"
  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "Public IP allocation method must be Static or Dynamic."
  }
}

variable "public_ip_sku" {
  description = "Public IP SKU (Standard/Basic)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Basic"], var.public_ip_sku)
    error_message = "Public IP SKU must be Standard or Basic."
  }
}

# Load Balancer Configuration
variable "create_load_balancer" {
  description = "Whether to create a load balancer"
  type        = bool
  default     = false
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "lb-k8s-app"
}

variable "load_balancer_sku" {
  description = "Load Balancer SKU (Standard/Basic)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Basic"], var.load_balancer_sku)
    error_message = "Load Balancer SKU must be Standard or Basic."
  }
}

# NAT Gateway Configuration
variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = false
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "natgw-k8s-app"
}

variable "nat_gateway_idle_timeout" {
  description = "NAT Gateway idle timeout in minutes"
  type        = number
  default     = 4
  validation {
    condition     = var.nat_gateway_idle_timeout >= 4 && var.nat_gateway_idle_timeout <= 120
    error_message = "NAT Gateway idle timeout must be between 4 and 120 minutes."
  }
}

# Application Gateway Configuration
variable "create_app_gateway" {
  description = "Whether to create an Application Gateway"
  type        = bool
  default     = false
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "appgw-k8s-app"
}

variable "app_gateway_sku" {
  description = "Application Gateway SKU"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_capacity" {
  description = "Application Gateway capacity (min and max instances)"
  type = object({
    min = number
    max = number
  })
  default = {
    min = 2
    max = 4
  }
}

# Private Endpoint Configuration
variable "create_private_endpoint" {
  description = "Whether to create a private endpoint"
  type        = bool
  default     = false
}

variable "private_endpoint_name" {
  description = "Name of the private endpoint"
  type        = string
  default     = "pe-k8s-app"
}

variable "private_endpoint_subnet_name" {
  description = "Name of the subnet for private endpoint"
  type        = string
  default     = null
}

# Service Endpoint Configuration
variable "service_endpoints" {
  description = "Service endpoints to enable on subnets"
  type        = list(string)
  default     = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
}

# DNS Configuration
variable "create_private_dns_zone" {
  description = "Whether to create a private DNS zone"
  type        = bool
  default     = false
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
  default     = "privatelink.database.windows.net"
}

variable "dns_servers" {
  description = "Custom DNS servers for VNet"
  type        = list(string)
  default     = []
}

# VNet Peering Configuration
variable "create_vnet_peering" {
  description = "Whether to create VNet peering"
  type        = bool
  default     = false
}

variable "peer_vnet_id" {
  description = "ID of the VNet to peer with"
  type        = string
  default     = null
}

variable "peer_vnet_name" {
  description = "Name of the peering connection"
  type        = string
  default     = "peer-k8s-app"
}

# Tags
variable "tags" {
  description = "Tags to apply to all networking resources"
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
