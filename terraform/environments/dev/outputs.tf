# Dev Environment - Outputs
# File: terraform/environments/dev/outputs.tf
# Description: Exports outputs from all modules for use by other stacks or visibility

# Azure Subscription/Tenant Info (from data block)
output "subscription_id" {
  description = "The Azure subscription ID"
  value       = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  description = "The Azure tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

# Resource Group Outputs
output "resource_group_id" {
  description = "The ID of the created resource group"
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "The name of the created resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  description = "The location of the created resource group"
  value       = module.resource_group.resource_group_location
}

# Storage Account Outputs
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = module.storage_account.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage_account.storage_account_name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint"
  value       = module.storage_account.storage_account_primary_blob_endpoint
}

output "storage_container_name" {
  description = "The name of the blob container"
  value       = module.storage_account.storage_container_name
}

# Existing Storage Account Data (if lookup enabled)
output "existing_storage_account_info" {
  description = "Information about an existing storage account (if lookup_existing_account is true)"
  value       = try(data.azurerm_storage_account.existing[0], null)
  sensitive   = false
}

# PCAM Networking - VNet Outputs
output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.pcam_networking.vnet_id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = module.pcam_networking.vnet_name
}

output "vnet_address_space" {
  description = "The address space of the Virtual Network"
  value       = module.pcam_networking.vnet_address_space
}

# PCAM Networking - Subnet Outputs
output "app_subnet_id" {
  description = "The ID of the application subnet"
  value       = module.pcam_networking.app_subnet_id
}

output "app_subnet_name" {
  description = "The name of the application subnet"
  value       = module.pcam_networking.app_subnet_name
}

output "app_subnet_address_prefix" {
  description = "The address prefix of the application subnet"
  value       = module.pcam_networking.app_subnet_address_prefix
}

output "aks_subnet_id" {
  description = "The ID of the AKS subnet"
  value       = module.pcam_networking.aks_subnet_id
}

output "aks_subnet_name" {
  description = "The name of the AKS subnet"
  value       = module.pcam_networking.aks_subnet_name
}

output "aks_subnet_address_prefix" {
  description = "The address prefix of the AKS subnet"
  value       = module.pcam_networking.aks_subnet_address_prefix
}

# PCAM Networking - NSG Outputs
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = module.pcam_networking.nsg_id
}

output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = module.pcam_networking.nsg_name
}

# PCAM Networking - Route Table Outputs
output "route_table_id" {
  description = "The ID of the route table"
  value       = module.pcam_networking.route_table_id
}

output "route_table_name" {
  description = "The name of the route table"
  value       = module.pcam_networking.route_table_name
}

# PCAM Networking - Public IP Outputs
output "public_ip_id" {
  description = "The ID of the public IP address"
  value       = module.pcam_networking.public_ip_id
}

output "public_ip_address" {
  description = "The IP address of the public IP"
  value       = module.pcam_networking.public_ip_address
}

# PCAM Networking - NAT Gateway Outputs
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.pcam_networking.nat_gateway_id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = module.pcam_networking.nat_gateway_public_ip
}

# PCAM Networking - Application Gateway Outputs
output "app_gateway_id" {
  description = "The ID of the Application Gateway"
  value       = module.pcam_networking.app_gateway_id
}

output "app_gateway_name" {
  description = "The name of the Application Gateway"
  value       = module.pcam_networking.app_gateway_name
}

# PCAM Networking - Complete Info
output "pcam_network_info" {
  description = "Complete PCAM network information"
  value       = module.pcam_networking.pcam_network_info
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = module.monitoring.log_analytics_workspace_id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = module.monitoring.log_analytics_workspace_name
}

output "app_insights_id" {
  description = "The ID of Application Insights"
  value       = module.monitoring.app_insights_id
}

output "app_insights_instrumentation_key" {
  description = "The instrumentation key for Application Insights"
  value       = module.monitoring.app_insights_instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "The connection string for Application Insights"
  value       = module.monitoring.app_insights_connection_string
  sensitive   = true
}

# Key Vault Outputs
output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

# Container Registry Outputs
output "container_registry_id" {
  description = "The ID of the Container Registry"
  value       = module.container_registry.registry_id
}

output "container_registry_name" {
  description = "The name of the Container Registry"
  value       = module.container_registry.registry_name
}

output "container_registry_login_server" {
  description = "The login server for the Container Registry"
  value       = module.container_registry.registry_login_server
}

output "acr_admin_username" {
  description = "Admin username for Container Registry"
  value       = module.container_registry.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password for Container Registry"
  value       = module.container_registry.admin_password
  sensitive   = true
}

# AKS Outputs
output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = module.aks.fqdn
}

output "aks_kube_config" {
  description = "Kubernetes config"
  value       = module.aks.kube_config
  sensitive   = true
}

output "aks_kube_config_raw" {
  description = "Raw Kubernetes config"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "aks_api_server_address" {
  description = "AKS API server address"
  value       = module.aks.api_server_address
}

output "aks_node_resource_group" {
  description = "The node resource group for AKS"
  value       = module.aks.node_resource_group
}

# App Service Outputs
output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = module.app_service.app_service_plan_id
}

output "backend_app_id" {
  description = "The ID of the backend App Service"
  value       = module.app_service.backend_app_id
}

output "backend_app_hostname" {
  description = "The default hostname of the backend App Service"
  value       = module.app_service.backend_app_default_hostname
}

output "frontend_app_id" {
  description = "The ID of the frontend App Service"
  value       = module.app_service.frontend_app_id
}

output "frontend_app_hostname" {
  description = "The default hostname of the frontend App Service"
  value       = module.app_service.frontend_app_default_hostname
}

# Function App Outputs
output "function_app_id" {
  description = "The ID of the Function App"
  value       = module.function_app.function_app_id
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = module.function_app.function_app_name
}

output "function_app_hostname" {
  description = "The default hostname of the Function App"
  value       = module.function_app.function_app_default_hostname
}

output "function_app_identity_principal_id" {
  description = "The principal ID of the Function App managed identity"
  value       = module.function_app.function_app_identity_principal_id
}
