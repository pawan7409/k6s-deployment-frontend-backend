terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0"
}

// Data block example: get client config (subscription and tenant info)
data "azurerm_client_config" "current" {}

module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group_name  = var.resource_group_name
  location             = var.azure_region
  tags                 = var.tags
  environment          = var.environment
}

module "storage_account" {
  source                = "../../modules/storage_account"
  storage_account_name  = var.storage_account_name
  resource_group_name   = module.resource_group.resource_group_name
  location              = var.azure_region
  storage_tier          = var.storage_tier
  storage_replication_type = var.storage_replication_type
  container_name        = var.container_name
  tags                  = var.tags
  create_unnecessary    = var.create_unnecessary
}

module "pcam_networking" {
  source              = "../../PCAM"
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  
  # Subnet Configuration
  subnet_name              = var.subnet_name
  subnet_address_prefix    = var.subnet_address_prefix
  aks_subnet_name          = var.aks_subnet_name
  aks_subnet_address_prefix = var.aks_subnet_address_prefix
  
  # NSG Configuration
  create_nsg = var.create_nsg
  nsg_name   = var.nsg_name
  
  # Route Table Configuration
  create_route_table = var.create_route_table
  route_table_name   = var.route_table_name
  
  # Optional Networking Resources
  create_public_ip       = var.create_public_ip
  public_ip_name         = var.public_ip_name
  create_nat_gateway     = var.create_nat_gateway
  nat_gateway_name       = var.nat_gateway_name
  create_app_gateway     = var.create_app_gateway
  app_gateway_name       = var.app_gateway_name
  create_private_dns_zone = var.create_private_dns_zone
  
  # Tags
  tags        = var.tags
  environment = var.environment
}

// Example of using a data block to look up an existing resource (if present)
data "azurerm_storage_account" "existing" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name

  # This data source will fail if the account does not exist; it's here to
  # demonstrate referencing existing infrastructure. In typical modules you
  # would conditionally use data sources via count or for_each.
  count = var.lookup_existing_account ? 1 : 0
}

# Monitoring Module (Log Analytics + Application Insights)
module "monitoring" {
  source              = "../../modules/monitoring"
  workspace_name      = var.log_analytics_workspace_name
  app_insights_name   = var.app_insights_name
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
  
  enable_container_insights    = var.enable_container_insights
  enable_key_vault_analytics   = var.enable_key_vault_analytics
  create_alert_rules           = var.create_alert_rules
  
  tags        = var.tags
  environment = var.environment
}

# Key Vault Module
module "key_vault" {
  source              = "../../modules/key_vault"
  key_vault_name      = var.key_vault_name
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  resource_group_id   = module.resource_group.resource_group_id
  
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  
  sku_name                    = var.key_vault_sku
  enable_purge_protection     = var.enable_key_vault_purge_protection
  soft_delete_retention_days  = var.key_vault_soft_delete_retention_days
  
  create_sample_secrets = var.create_key_vault_secrets
  
  tags        = var.tags
  environment = var.environment
}

# Container Registry Module
module "container_registry" {
  source              = "../../modules/container_registry"
  registry_name       = var.container_registry_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.azure_region
  
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  public_network_access_enabled = var.acr_public_network_access
  enable_zone_redundancy        = var.acr_enable_zone_redundancy
  enable_webhook                = var.acr_enable_webhook
  enable_geo_replication        = var.acr_enable_geo_replication
  
  tags        = var.tags
  environment = var.environment
}

# AKS Module
module "aks" {
  source              = "../../modules/aks"
  cluster_name        = var.aks_cluster_name
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  dns_prefix          = var.aks_dns_prefix
  
  kubernetes_version = var.kubernetes_version
  
  # Node Pool Configuration
  default_node_pool_name = var.aks_default_node_pool_name
  node_vm_size           = var.aks_node_vm_size
  initial_node_count     = var.aks_initial_node_count
  min_node_count         = var.aks_min_node_count
  max_node_count         = var.aks_max_node_count
  node_labels            = var.aks_node_labels
  availability_zones     = var.aks_availability_zones
  
  # Service Principal
  service_principal_client_id     = var.aks_service_principal_client_id
  service_principal_client_secret = var.aks_service_principal_client_secret
  
  # Monitoring
  enable_monitoring          = var.aks_enable_monitoring
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  
  # Network
  vnet_subnet_id           = module.pcam_networking.aks_subnet_id
  network_plugin           = var.aks_network_plugin
  network_policy           = var.aks_network_policy
  service_cidr             = var.aks_service_cidr
  dns_service_ip           = var.aks_dns_service_ip
  api_server_authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
  
  # Workload Node Pool
  create_workload_node_pool = var.aks_create_workload_node_pool
  workload_node_pool_name   = var.aks_workload_node_pool_name
  workload_node_vm_size     = var.aks_workload_node_vm_size
  workload_node_count       = var.aks_workload_node_count
  
  tags        = var.tags
  environment = var.environment
  
  depends_on = [
    module.monitoring,
    module.pcam_networking
  ]
}

# App Service Module
module "app_service" {
  source              = "../../modules/app_service"
  app_service_plan_name = var.app_service_plan_name
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  
  sku_name = var.app_service_sku
  
  deploy_backend     = var.deploy_backend_app_service
  backend_app_name   = var.backend_app_service_name
  backend_app_settings = var.backend_app_settings
  
  deploy_frontend    = var.deploy_frontend_app_service
  frontend_app_name  = var.frontend_app_service_name
  frontend_app_settings = var.frontend_app_settings
  
  app_insights_connection_string = module.monitoring.app_insights_connection_string
  
  enable_autoscaling = var.app_service_enable_autoscaling
  default_capacity   = var.app_service_default_capacity
  minimum_capacity   = var.app_service_minimum_capacity
  maximum_capacity   = var.app_service_maximum_capacity
  
  tags        = var.tags
  environment = var.environment
  
  depends_on = [module.monitoring]
}

# Function App Module
module "function_app" {
  source              = "../../modules/function_app"
  function_app_name   = var.function_app_name
  function_app_plan_name = var.function_app_plan_name
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  
  function_app_sku = var.function_app_sku
  
  storage_account_name       = module.storage_account.storage_account_name
  storage_account_access_key = module.storage_account.primary_access_key
  
  app_insights_connection_string = module.monitoring.app_insights_connection_string
  
  function_app_settings = var.function_app_settings
  
  create_staging_slot = var.function_app_create_staging_slot
  enable_autoscaling  = var.function_app_enable_autoscaling
  
  tags        = var.tags
  environment = var.environment
  
  depends_on = [module.storage_account, module.monitoring]
}
