# Production Environment Variables
# File: prod.tfvars
# Usage: terraform apply -var-file="prod.tfvars"

# General Configuration
environment              = "prod"
azure_region             = "eastus"
resource_group_name      = "rg-k8s-app-prod"
project_name             = "k8sapp"

# Network Configuration
vnet_name                = "vnet-prod"
vnet_address_space       = ["10.2.0.0/16"]
subnet_name              = "subnet-prod"
subnet_address_prefix    = "10.2.1.0/24"
aks_subnet_name          = "subnet-aks-prod"
aks_subnet_address_prefix = "10.2.2.0/24"

# AKS Cluster Configuration
aks_cluster_name         = "aks-prod-cluster"
kubernetes_version       = "1.28"
vm_size                  = "Standard_D2s_v3"
node_count               = 5
max_pods                 = 110

# Storage Account Configuration
storage_account_name     = "stgprodk8sapp"
storage_tier             = "Premium"
storage_replication_type = "GZRS"
container_name           = "prod-container"

# App Service Configuration
app_service_plan_name    = "asp-prod"
app_service_name         = "app-prod-k8sapp"
app_service_sku          = "S1"
enable_https_only        = true

# Function App Configuration
function_app_name        = "func-prod-k8sapp"
function_app_runtime     = "python"
function_app_version     = "3.11"

# Container Registry Configuration
registry_name            = "acrprodk8sapp"
registry_sku             = "Premium"
admin_enabled            = false

# Tagging
tags = {
  Environment = "Production"
  CreatedBy   = "Terraform"
  Purpose     = "K8s Application Deployment"
  CostCenter  = "Engineering"
  ManagedBy   = "DevOps"
  Compliance  = "Required"
}
