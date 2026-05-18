# PCAM Networking Module - Outputs
# File: PCAM/outputs.tf
# Description: Networking infrastructure outputs

# Virtual Network Outputs
output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.pcam_vnet.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.pcam_vnet.name
}

output "vnet_address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.pcam_vnet.address_space
}

# Application Subnet Outputs
output "app_subnet_id" {
  description = "The ID of the application subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "app_subnet_name" {
  description = "The name of the application subnet"
  value       = azurerm_subnet.app_subnet.name
}

output "app_subnet_address_prefix" {
  description = "The address prefix of the application subnet"
  value       = azurerm_subnet.app_subnet.address_prefixes[0]
}

# AKS Subnet Outputs
output "aks_subnet_id" {
  description = "The ID of the AKS subnet"
  value       = azurerm_subnet.aks_subnet.id
}

output "aks_subnet_name" {
  description = "The name of the AKS subnet"
  value       = azurerm_subnet.aks_subnet.name
}

output "aks_subnet_address_prefix" {
  description = "The address prefix of the AKS subnet"
  value       = azurerm_subnet.aks_subnet.address_prefixes[0]
}

# Network Security Group Outputs
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = try(azurerm_network_security_group.pcam_nsg[0].id, null)
}

output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = try(azurerm_network_security_group.pcam_nsg[0].name, null)
}

# Route Table Outputs
output "route_table_id" {
  description = "The ID of the route table"
  value       = try(azurerm_route_table.pcam_route_table[0].id, null)
}

output "route_table_name" {
  description = "The name of the route table"
  value       = try(azurerm_route_table.pcam_route_table[0].name, null)
}

# Public IP Outputs
output "public_ip_id" {
  description = "The ID of the public IP address"
  value       = try(azurerm_public_ip.pcam_public_ip[0].id, null)
}

output "public_ip_address" {
  description = "The IP address of the public IP"
  value       = try(azurerm_public_ip.pcam_public_ip[0].ip_address, null)
}

# Network Interface Outputs
output "nic_id" {
  description = "The ID of the network interface"
  value       = try(azurerm_network_interface.pcam_nic[0].id, null)
}

output "nic_private_ip_address" {
  description = "The private IP address of the network interface"
  value       = try(azurerm_network_interface.pcam_nic[0].private_ip_address, null)
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = try(azurerm_nat_gateway.pcam_nat_gateway[0].id, null)
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = try(azurerm_public_ip.nat_gateway_public_ip[0].ip_address, null)
}

# Application Gateway Outputs
output "app_gateway_id" {
  description = "The ID of the Application Gateway"
  value       = try(azurerm_application_gateway.pcam_app_gateway[0].id, null)
}

output "app_gateway_name" {
  description = "The name of the Application Gateway"
  value       = try(azurerm_application_gateway.pcam_app_gateway[0].name, null)
}

# Private DNS Zone Outputs
output "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  value       = try(azurerm_private_dns_zone.pcam_private_dns[0].id, null)
}

output "private_dns_zone_name" {
  description = "The name of the private DNS zone"
  value       = try(azurerm_private_dns_zone.pcam_private_dns[0].name, null)
}

# VNet Peering Outputs
output "vnet_peering_id" {
  description = "The ID of the VNet peering"
  value       = try(azurerm_virtual_network_peering.pcam_peering[0].id, null)
}

# Complete Network Information
output "pcam_network_info" {
  description = "Complete PCAM network information"
  value = {
    vnet                = local.vnet_info
    subnets             = local.subnets_info
    nsg_enabled         = var.create_nsg
    route_table_enabled = var.create_route_table
    public_ip_enabled   = var.create_public_ip
    nat_gateway_enabled = var.create_nat_gateway
    app_gateway_enabled = var.create_app_gateway
    private_dns_enabled = var.create_private_dns_zone
  }
}

# Locals exported for environment output aggregation
output "all_subnet_ids" {
  description = "Map of all subnet IDs"
  value = {
    app_subnet = azurerm_subnet.app_subnet.id
    aks_subnet = azurerm_subnet.aks_subnet.id
  }
}
