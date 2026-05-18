# Staging Environment Variables
# File: staging.tfvars
# Usage: terraform apply -var-file="staging.tfvars"

# General Configuration
environment              = "staging"
azure_region             = "eastus"
resource_group_name      = "rg-k8s-app-staging"
project_name             = "k8sapp"

# Network Configuration
vnet_name                = "vnet-staging"
vnet_address_space       = ["10.1.0.0/16"]
subnet_name              = "subnet-staging"
subnet_address_prefix    = "10.1.1.0/24"
aks_subnet_name          = "subnet-aks-staging"
aks_subnet_address_prefix = "10.1.2.0/24"

# AKS Cluster Configuration
aks_cluster_name         = "aks-staging-cluster"
kubernetes_version       = "1.28"
vm_size                  = "Standard_B2s"
node_count               = 3
max_pods                 = 110

# Storage Account Configuration
storage_account_name     = "stgstagingk8sapp"
storage_tier             = "Standard"
storage_replication_type = "GRS"
container_name           = "staging-container"

# App Service Configuration
app_service_plan_name    = "asp-staging"
app_service_name         = "app-staging-k8sapp"
app_service_sku          = "B2"
enable_https_only        = true

# Function App Configuration
function_app_name        = "func-staging-k8sapp"
function_app_runtime     = "python"
function_app_version     = "3.11"

# Container Registry Configuration
registry_name            = "acrstagingk8sapp"
registry_sku             = "Standard"
admin_enabled            = true

# Tagging
tags = {
  Environment = "Staging"
  CreatedBy   = "Terraform"
  Purpose     = "K8s Application Deployment"
  CostCenter  = "Engineering"
  ManagedBy   = "DevOps"
}
