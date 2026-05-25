# Development Environment Variables
# File: dev.tfvars
# Usage: terraform apply -var-file="dev.tfvars"

# General Configuration
environment              = "dev"
azure_region             = "eastus"
resource_group_name      = "rg-k8s-app-dev"
project_name             = "k8sapp"

# Network Configuration
vnet_name                = "vnet-dev"
vnet_address_space       = ["10.0.0.0/16"]
subnet_name              = "subnet-dev"
subnet_address_prefix    = "10.0.1.0/24"
aks_subnet_name          = "subnet-aks-dev"
aks_subnet_address_prefix = "10.0.2.0/24"

# Network Security Group Configuration
create_nsg = true
nsg_name   = "nsg-k8s-app-dev"

# Route Table Configuration
create_route_table = true
route_table_name   = "rt-k8s-app-dev"

# Public IP Configuration
create_public_ip = false
public_ip_name   = "pip-k8s-app-dev"

# NAT Gateway Configuration
create_nat_gateway = false
nat_gateway_name   = "natgw-k8s-app-dev"

# Application Gateway Configuration
create_app_gateway = false
app_gateway_name   = "appgw-k8s-app-dev"

# Private DNS Zone Configuration
create_private_dns_zone = false

# AKS Cluster Configuration
aks_cluster_name         = "aks-dev-cluster"
kubernetes_version       = "1.28"
vm_size                  = "Standard_B2s"
node_count               = 2
max_pods                 = 110

# Storage Account Configuration
storage_account_name     = "stgdevk8sapp"
storage_tier             = "Standard"
storage_replication_type = "LRS"
container_name           = "dev-container"

# App Service Configuration
app_service_plan_name    = "asp-dev"
app_service_name         = "app-dev-k8sapp"
app_service_sku          = "B1"
enable_https_only        = true

# Function App Configuration
function_app_name        = "func-dev-k8sapp"
function_app_runtime     = "python"
function_app_version     = "3.11"

# Container Registry Configuration
registry_name            = "acrdevk8sapp"
registry_sku             = "Basic"
admin_enabled            = true

# Monitoring Configuration
log_analytics_workspace_name = "law-dev-k8s-monitoring"
app_insights_name            = "appinsights-dev-k8s"
log_analytics_sku            = "PerGB2018"
log_analytics_retention_days = 30
enable_container_insights    = true
enable_key_vault_analytics   = true
create_alert_rules          = true

# Key Vault Configuration
key_vault_name                          = "kv-dev-k8s-app"
key_vault_sku                          = "standard"
enable_key_vault_purge_protection      = false
key_vault_soft_delete_retention_days   = 7
create_key_vault_secrets               = false

# Container Registry Configuration (Updated)
container_registry_name = "acrdevk8sapp"
acr_sku                 = "Standard"
acr_admin_enabled       = true
acr_public_network_access = true
acr_enable_zone_redundancy = false
acr_enable_webhook      = false
acr_enable_geo_replication = false

# AKS Configuration (Updated)
aks_cluster_name           = "aks-dev-cluster"
aks_dns_prefix             = "aks-dev-k8s"
kubernetes_version         = "1.28"
aks_default_node_pool_name = "default"
aks_node_vm_size           = "Standard_B2s"
aks_initial_node_count     = 2
aks_min_node_count         = 1
aks_max_node_count         = 5
aks_enable_monitoring      = true
aks_network_plugin         = "azure"
aks_network_policy         = "azure"
aks_create_workload_node_pool = false

# Service Principal for AKS (IMPORTANT: Set these values)
# Generate these via: az ad sp create-for-rbac --name "aks-dev-sp"
aks_service_principal_client_id     = "" # TODO: Set your SP Client ID
aks_service_principal_client_secret = "" # TODO: Set your SP Client Secret

# App Service Configuration (Updated)
app_service_plan_name           = "asp-dev-k8s"
app_service_sku                 = "B2"
deploy_backend_app_service      = false
backend_app_service_name        = "app-dev-backend-k8s"
deploy_frontend_app_service     = false

# ========================================
# Backend Storage Account Configuration
# ========================================
backend_storage_rg_name         = "rg-backend-storage-dev"
backend_storage_account_name    = "stbackenddev"
backend_storage_replication_type = "LRS"
backend_container_name          = "backend-data"
enable_backend_storage          = true

# Note: Storage account names must be globally unique and 3-24 characters
# Only lowercase letters and numbers allowed
# If stbackenddev conflicts, change to: stbackend${environment}${random}
frontend_app_service_name       = "app-dev-frontend-k8s"
app_service_enable_autoscaling  = true
app_service_default_capacity    = 2
app_service_minimum_capacity    = 1
app_service_maximum_capacity    = 5

# Function App Configuration (Updated)
function_app_name                = "func-dev-k8s-app"
function_app_plan_name           = "asp-func-dev-k8s"
function_app_sku                 = "Y1"
function_app_create_staging_slot = true
function_app_enable_autoscaling  = true

# Tagging
tags = {
  Environment = "Development"
  CreatedBy   = "Terraform"
  Purpose     = "K8s Application Deployment"
  CostCenter  = "Engineering"
  ManagedBy   = "DevOps"
}
