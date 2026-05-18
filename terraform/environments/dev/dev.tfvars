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

# Tagging
tags = {
  Environment = "Development"
  CreatedBy   = "Terraform"
  Purpose     = "K8s Application Deployment"
  CostCenter  = "Engineering"
  ManagedBy   = "DevOps"
}
