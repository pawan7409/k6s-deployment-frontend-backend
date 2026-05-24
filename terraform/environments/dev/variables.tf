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

# Monitoring Variables
variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics Workspace"
  default     = "law-k8s-monitoring"
}

variable "app_insights_name" {
  type        = string
  description = "Name of Application Insights"
  default     = "appinsights-k8s"
}

variable "log_analytics_sku" {
  type        = string
  description = "SKU for Log Analytics"
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  type        = number
  description = "Retention period for logs in days"
  default     = 30
}

variable "enable_container_insights" {
  type        = bool
  description = "Enable Container Insights"
  default     = true
}

variable "enable_key_vault_analytics" {
  type        = bool
  description = "Enable Key Vault Analytics"
  default     = true
}

variable "create_alert_rules" {
  type        = bool
  description = "Create alert rules"
  default     = true
}

# Key Vault Variables
variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault"
  default     = "kv-k8s-app"
}

variable "key_vault_sku" {
  type        = string
  description = "SKU for Key Vault"
  default     = "standard"
}

variable "enable_key_vault_purge_protection" {
  type        = bool
  description = "Enable purge protection for Key Vault"
  default     = false
}

variable "key_vault_soft_delete_retention_days" {
  type        = number
  description = "Soft delete retention days for Key Vault"
  default     = 7
}

variable "create_key_vault_secrets" {
  type        = bool
  description = "Create sample secrets in Key Vault"
  default     = false
}

# Container Registry Variables
variable "container_registry_name" {
  type        = string
  description = "Name of the Container Registry"
  default     = "acrk8sapp"
}

variable "acr_sku" {
  type        = string
  description = "SKU for Container Registry"
  default     = "Standard"
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Enable admin user for ACR"
  default     = true
}

variable "acr_public_network_access" {
  type        = bool
  description = "Enable public network access for ACR"
  default     = true
}

variable "acr_enable_zone_redundancy" {
  type        = bool
  description = "Enable zone redundancy for ACR"
  default     = false
}

variable "acr_enable_webhook" {
  type        = bool
  description = "Enable webhook for ACR"
  default     = false
}

variable "acr_enable_geo_replication" {
  type        = bool
  description = "Enable geo-replication for ACR"
  default     = false
}

# AKS Variables
variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "aks-k8s-cluster"
}

variable "aks_dns_prefix" {
  type        = string
  description = "DNS prefix for AKS"
  default     = "aks-k8s"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.27"
}

variable "aks_default_node_pool_name" {
  type        = string
  description = "Name of the default node pool"
  default     = "default"
}

variable "aks_node_vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_DS2_v2"
}

variable "aks_initial_node_count" {
  type        = number
  description = "Initial node count"
  default     = 2
}

variable "aks_min_node_count" {
  type        = number
  description = "Minimum node count"
  default     = 1
}

variable "aks_max_node_count" {
  type        = number
  description = "Maximum node count"
  default     = 10
}

variable "aks_node_labels" {
  type        = map(string)
  description = "Labels for AKS nodes"
  default = {
    environment = "production"
  }
}

variable "aks_availability_zones" {
  type        = list(string)
  description = "Availability zones for AKS"
  default     = []
}

variable "aks_service_principal_client_id" {
  type        = string
  description = "Service Principal Client ID for AKS"
  sensitive   = true
}

variable "aks_service_principal_client_secret" {
  type        = string
  description = "Service Principal Client Secret for AKS"
  sensitive   = true
}

variable "aks_enable_monitoring" {
  type        = bool
  description = "Enable monitoring for AKS"
  default     = true
}

variable "aks_network_plugin" {
  type        = string
  description = "Network plugin for AKS"
  default     = "azure"
}

variable "aks_network_policy" {
  type        = string
  description = "Network policy for AKS"
  default     = "azure"
}

variable "aks_service_cidr" {
  type        = string
  description = "Service CIDR for AKS"
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "DNS service IP for AKS"
  default     = "10.0.0.10"
}

variable "aks_api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "Authorized IP ranges for AKS API server"
  default     = []
}

variable "aks_create_workload_node_pool" {
  type        = bool
  description = "Create workload node pool"
  default     = true
}

variable "aks_workload_node_pool_name" {
  type        = string
  description = "Name of the workload node pool"
  default     = "workload"
}

variable "aks_workload_node_vm_size" {
  type        = string
  description = "VM size for workload nodes"
  default     = "Standard_DS3_v2"
}

variable "aks_workload_node_count" {
  type        = number
  description = "Workload node count"
  default     = 2
}

# App Service Variables
variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan"
  default     = "asp-k8s-app"
}

variable "app_service_sku" {
  type        = string
  description = "SKU for App Service"
  default     = "B2"
}

variable "deploy_backend_app_service" {
  type        = bool
  description = "Deploy backend App Service"
  default     = false
}

variable "backend_app_service_name" {
  type        = string
  description = "Name of the backend App Service"
  default     = "app-k8s-backend"
}

variable "backend_app_settings" {
  type        = map(string)
  description = "App settings for backend"
  default     = {}
}

variable "deploy_frontend_app_service" {
  type        = bool
  description = "Deploy frontend App Service"
  default     = false
}

variable "frontend_app_service_name" {
  type        = string
  description = "Name of the frontend App Service"
  default     = "app-k8s-frontend"
}

variable "frontend_app_settings" {
  type        = map(string)
  description = "App settings for frontend"
  default     = {}
}

variable "app_service_enable_autoscaling" {
  type        = bool
  description = "Enable autoscaling for App Service"
  default     = true
}

variable "app_service_default_capacity" {
  type        = number
  description = "Default capacity for App Service"
  default     = 2
}

variable "app_service_minimum_capacity" {
  type        = number
  description = "Minimum capacity for App Service"
  default     = 1
}

variable "app_service_maximum_capacity" {
  type        = number
  description = "Maximum capacity for App Service"
  default     = 10
}

# Function App Variables
variable "function_app_name" {
  type        = string
  description = "Name of the Function App"
  default     = "func-k8s-app"
}

variable "function_app_plan_name" {
  type        = string
  description = "Name of the Function App Plan"
  default     = "asp-func-k8s"
}

variable "function_app_sku" {
  type        = string
  description = "SKU for Function App"
  default     = "Y1"
}

variable "function_app_settings" {
  type        = map(string)
  description = "App settings for Function App"
  default     = {}
}

variable "function_app_create_staging_slot" {
  type        = bool
  description = "Create staging slot for Function App"
  default     = true
}

variable "function_app_enable_autoscaling" {
  type        = bool
  description = "Enable autoscaling for Function App"
  default     = true
}
