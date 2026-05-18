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
