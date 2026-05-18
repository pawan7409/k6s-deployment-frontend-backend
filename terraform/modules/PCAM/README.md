# PCAM Networking Module Documentation

**Path:** `terraform/PCAM/`  
**Purpose:** Unified networking configuration module for Azure infrastructure  
**Status:** ✅ Complete and integrated with dev environment

---

## Overview

PCAM (Unified Networking Configuration) is a comprehensive Terraform module that manages all networking infrastructure for Kubernetes applications in Azure. It replaces the empty `modules/network/` folder with a production-ready networking solution.

---

## Features

### Core Networking
- ✅ Virtual Network (VNet) with configurable address space
- ✅ Multiple subnets (Application, AKS) with service endpoints
- ✅ Network Security Groups (NSG) with customizable rules
- ✅ Route Tables with configurable routes

### Advanced Networking
- ✅ Public IP addresses (Static/Dynamic)
- ✅ Network Interfaces (NIC) with multiple IP configurations
- ✅ NAT Gateway for outbound connectivity
- ✅ Application Gateway for load balancing
- ✅ Private DNS zones for internal name resolution
- ✅ VNet Peering for multi-VNet communication

### Flexibility
- ✅ All resources are optional and controllable via boolean flags
- ✅ Conditional creation using Terraform `count`
- ✅ Comprehensive variable validation
- ✅ Service endpoints configuration
- ✅ Custom NSG rules support

---

## Module Structure

```
terraform/PCAM/
├── variables.tf         # 200+ lines - All networking parameters
├── networking.tf        # 350+ lines - Resource definitions
└── outputs.tf           # 100+ lines - Output exports
```

---

## Variables

### Core Variables

#### Virtual Network
```hcl
variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the Virtual Network"
}
```

#### Location & Resource Group
```hcl
variable "location" {
  type        = string
  description = "Azure region for networking resources"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}
```

#### Subnets
```hcl
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
```

### Optional Features (Conditional)

#### Network Security Group
```hcl
variable "create_nsg" {
  type    = bool
  default = true
}

variable "nsg_name" {
  type    = string
  default = "nsg-k8s-app"
}

variable "nsg_rules" {
  type = list(object({...}))
  default = [HTTP, HTTPS rules]
}
```

#### Route Table
```hcl
variable "create_route_table" {
  type    = bool
  default = true
}

variable "route_table_name" {
  type    = string
  default = "rt-k8s-app"
}

variable "routes" {
  type = list(object({...}))
  default = [Default internet route]
}
```

#### Public IP
```hcl
variable "create_public_ip" {
  type    = bool
  default = false
}

variable "public_ip_name" {
  type    = string
  default = "pip-k8s-app"
}

variable "public_ip_allocation_method" {
  type    = string
  default = "Static"
}
```

#### Network Interface
```hcl
variable "create_nic" {
  type    = bool
  default = false
}

variable "nic_name" {
  type    = string
  default = "nic-k8s-app"
}
```

#### NAT Gateway
```hcl
variable "create_nat_gateway" {
  type    = bool
  default = false
}

variable "nat_gateway_name" {
  type    = string
  default = "natgw-k8s-app"
}
```

#### Application Gateway
```hcl
variable "create_app_gateway" {
  type    = bool
  default = false
}

variable "app_gateway_name" {
  type    = string
  default = "appgw-k8s-app"
}
```

#### Private DNS Zone
```hcl
variable "create_private_dns_zone" {
  type    = bool
  default = false
}

variable "private_dns_zone_name" {
  type    = string
  default = "privatelink.database.windows.net"
}
```

#### VNet Peering
```hcl
variable "create_vnet_peering" {
  type    = bool
  default = false
}

variable "peer_vnet_id" {
  type    = string
  default = null
}
```

### Common Variables
```hcl
variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

---

## Resources Created

### Always Created
1. **Virtual Network** - `azurerm_virtual_network`
2. **Application Subnet** - `azurerm_subnet`
3. **AKS Subnet** - `azurerm_subnet`

### Conditionally Created

**Network Security Group** (default: true)
- `azurerm_network_security_group`
- `azurerm_network_security_rule` (multiple)
- `azurerm_subnet_network_security_group_association` (x2)

**Route Table** (default: true)
- `azurerm_route_table`
- `azurerm_route` (multiple)
- `azurerm_subnet_route_table_association` (x2)

**Public IP** (default: false)
- `azurerm_public_ip`

**Network Interface** (default: false)
- `azurerm_network_interface`

**NAT Gateway** (default: false)
- `azurerm_nat_gateway`
- `azurerm_public_ip` (for NAT Gateway)
- `azurerm_nat_gateway_public_ip_association`
- `azurerm_subnet_nat_gateway_association`

**Application Gateway** (default: false)
- `azurerm_application_gateway`

**Private DNS Zone** (default: false)
- `azurerm_private_dns_zone`
- `azurerm_private_dns_zone_virtual_network_link`

**VNet Peering** (default: false)
- `azurerm_virtual_network_peering`

---

## Outputs

### VNet Outputs
- `vnet_id` - Virtual Network ID
- `vnet_name` - Virtual Network name
- `vnet_address_space` - VNet address space

### Subnet Outputs
- `app_subnet_id` - Application subnet ID
- `app_subnet_name` - Application subnet name
- `app_subnet_address_prefix` - Application subnet CIDR
- `aks_subnet_id` - AKS subnet ID
- `aks_subnet_name` - AKS subnet name
- `aks_subnet_address_prefix` - AKS subnet CIDR

### NSG Outputs
- `nsg_id` - Network Security Group ID
- `nsg_name` - Network Security Group name

### Route Table Outputs
- `route_table_id` - Route table ID
- `route_table_name` - Route table name

### Public IP Outputs
- `public_ip_id` - Public IP ID
- `public_ip_address` - Public IP address

### Network Interface Outputs
- `nic_id` - Network Interface ID
- `nic_private_ip_address` - Private IP address

### NAT Gateway Outputs
- `nat_gateway_id` - NAT Gateway ID
- `nat_gateway_public_ip` - NAT Gateway public IP

### Application Gateway Outputs
- `app_gateway_id` - Application Gateway ID
- `app_gateway_name` - Application Gateway name

### Private DNS Outputs
- `private_dns_zone_id` - Private DNS Zone ID
- `private_dns_zone_name` - Private DNS Zone name

### Aggregate Outputs
- `pcam_network_info` - Complete network information summary
- `all_subnet_ids` - Map of all subnet IDs

---

## Usage Example

### Basic Usage (Dev Environment)

**variables.tf:**
```hcl
variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_name" {
  type = string
}

variable "create_nsg" {
  type    = bool
  default = true
}
```

**main.tf:**
```hcl
module "pcam_networking" {
  source              = "../../PCAM"
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  
  subnet_name              = var.subnet_name
  subnet_address_prefix    = var.subnet_address_prefix
  aks_subnet_name          = var.aks_subnet_name
  aks_subnet_address_prefix = var.aks_subnet_address_prefix
  
  create_nsg = var.create_nsg
  nsg_name   = var.nsg_name
  
  create_route_table = var.create_route_table
  route_table_name   = var.route_table_name
  
  create_public_ip   = var.create_public_ip
  create_nat_gateway = var.create_nat_gateway
  create_app_gateway = var.create_app_gateway
  
  tags        = var.tags
  environment = var.environment
}
```

**dev.tfvars:**
```hcl
vnet_name                = "vnet-dev"
vnet_address_space       = ["10.0.0.0/16"]
subnet_name              = "subnet-dev"
subnet_address_prefix    = "10.0.1.0/24"
aks_subnet_name          = "subnet-aks-dev"
aks_subnet_address_prefix = "10.0.2.0/24"

create_nsg = true
nsg_name   = "nsg-k8s-app-dev"

create_route_table = true
route_table_name   = "rt-k8s-app-dev"

create_public_ip   = false
create_nat_gateway = false
create_app_gateway = false
```

### Advanced: Enable NAT Gateway

**dev.tfvars:**
```hcl
create_nat_gateway = true
nat_gateway_name   = "natgw-k8s-app-dev"
```

This will create:
- NAT Gateway
- Public IP for NAT Gateway
- NAT Gateway association with app subnet

### Advanced: Enable Application Gateway

**dev.tfvars:**
```hcl
create_public_ip   = true
public_ip_name     = "pip-k8s-app-dev"
create_app_gateway = true
app_gateway_name   = "appgw-k8s-app-dev"
```

---

## Integration with Environment

The PCAM module is fully integrated with `terraform/environments/dev/`:

### dev/variables.tf
Contains all PCAM variable declarations with proper defaults and validation.

### dev/main.tf
Calls PCAM module and passes all networking variables:
```hcl
module "pcam_networking" {
  source = "../../PCAM"
  # ... all variables passed
}
```

### dev/outputs.tf
Exports 20+ networking outputs for visibility and downstream use.

### dev/dev.tfvars
Provides environment-specific values for all networking resources.

---

## Security Considerations

### Network Security Group (NSG)
- Default rules allow HTTP (80) and HTTPS (443) inbound
- Rules have numeric priorities (100, 110, etc.)
- Service endpoints configured: Storage, SQL, KeyVault
- Can be customized via `nsg_rules` variable

### Subnets
- Separate subnets for application and AKS
- Both subnets have service endpoints enabled
- NSG associated with both subnets

### Public IP
- Optional and disabled by default
- Can be Static or Dynamic
- Supports Standard or Basic SKU

### NAT Gateway
- Provides secure outbound connectivity
- Static public IP for predictable outbound addresses
- Configurable idle timeout (4-120 minutes)

---

## Cost Considerations

### Free Resources
- Virtual Network
- Subnets
- Route Tables
- Network Security Groups

### Paid Resources
- **Public IP Address** - ~$2-3/month
- **NAT Gateway** - ~$32/month + data processing
- **Application Gateway** - Starting at ~$16/month
- **Private DNS Zone** - ~$0.50/month + queries

### Recommendations
- Enable only needed features
- Use defaults for development
- Review costs before enabling NAT Gateway/App Gateway
- Use Private DNS Zone only when needed

---

## Deployment Commands

### Initialize
```bash
cd terraform/environments/dev
terraform init
```

### Validate
```bash
terraform validate
```

### Plan
```bash
terraform plan -var-file="dev.tfvars"
```

### Apply
```bash
terraform apply -var-file="dev.tfvars"
```

### View Networking Outputs
```bash
terraform output pcam_network_info
```

### Get Specific Values
```bash
terraform output vnet_id
terraform output app_subnet_id
terraform output aks_subnet_id
```

---

## Troubleshooting

### NSG Rules Not Applied
- Ensure `create_nsg = true` in dev.tfvars
- Check NSG association is created
- Review NSG rules have correct priority

### Subnets Not Created
- Verify `vnet_address_space` and subnet prefixes don't overlap
- Check address prefixes are within VNet space
- Ensure subnet names are unique within VNet

### Public IP Not Assigned
- Enable `create_public_ip = true` in dev.tfvars
- Check allocation method (Static/Dynamic)
- Verify SKU (Standard/Basic)

### NAT Gateway Errors
- Ensure `create_nat_gateway = true`
- Check that public IP is created (automatic)
- Verify NAT Gateway is associated with subnet

### Application Gateway Issues
- Requires public IP, enable both flags
- Check backend pool configuration
- Verify HTTP listener settings

---

## Migration from modules/network/

The old empty `modules/network/` folder can be removed.  
All networking functionality is now in PCAM:
- ✅ PCAM has all networking resources
- ✅ PCAM is integrated with dev environment
- ✅ PCAM outputs are exported
- ✅ Old network folder is empty and unused

---

## Future Enhancements

Potential additions to PCAM:
- Azure Firewall configuration
- VPN Gateway setup
- ExpressRoute configuration
- Service Bus with Private Endpoints
- More complex NSG rule management
- Network Watcher integration

---

## Support

For issues or questions about PCAM networking:
1. Check variable defaults in `PCAM/variables.tf`
2. Review outputs in `PCAM/outputs.tf`
3. Check integration in `environments/dev/main.tf`
4. Review environment configuration in `dev/dev.tfvars`

---

**Status:** ✅ Production Ready  
**Integrated:** ✅ Yes  
**Outputs Exported:** ✅ Yes  
**Documentation:** ✅ Complete
