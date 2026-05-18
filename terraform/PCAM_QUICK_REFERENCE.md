# PCAM Quick Reference Guide

**Quick start guide for PCAM networking module**

---

## 📁 File Locations

```
terraform/
├── PCAM/                          ← Networking module
│   ├── variables.tf               ← 50+ networking parameters
│   ├── networking.tf              ← All resource definitions
│   ├── outputs.tf                 ← 20+ outputs
│   ├── README.md                  ← Full documentation
│   └── (no .tfvars in module)
│
├── environments/dev/
│   ├── main.tf                    ← Calls PCAM module
│   ├── variables.tf               ← 25+ networking vars (+ others)
│   ├── outputs.tf                 ← Networking outputs (+ others)
│   ├── dev.tfvars                 ← Networking values (+ others)
│   └── provider.tf
│
└── modules/
    ├── resource_group/            ← RG module
    ├── storage_account/           ← Storage module
    └── network/                   ← EMPTY (replaced by PCAM)
```

---

## 🔑 Key Concepts

### What is PCAM?
**PCAM** = Unified Networking Configuration  
Replaces the empty `modules/network/` folder with a comprehensive networking solution

### What's Included?
1. **Core:** VNet, Subnets, NSG, Route Tables
2. **Optional:** Public IP, NAT Gateway, App Gateway, Private DNS
3. **Advanced:** VNet Peering, NIC, Service Endpoints

### What's Conditional?
All resources except VNet and Subnets are optional:
- NSG (default: enabled)
- Route Table (default: enabled)
- Public IP (default: disabled)
- NAT Gateway (default: disabled)
- App Gateway (default: disabled)
- Private DNS (default: disabled)

---

## ⚙️ Configuration Quick Reference

### Minimal Dev Setup
```hcl
# terraform/environments/dev/dev.tfvars
vnet_name                = "vnet-dev"
vnet_address_space       = ["10.0.0.0/16"]
subnet_name              = "subnet-dev"
subnet_address_prefix    = "10.0.1.0/24"
aks_subnet_name          = "subnet-aks-dev"
aks_subnet_address_prefix = "10.0.2.0/24"

create_nsg = true
create_route_table = true
```

### Add Public IP
```hcl
create_public_ip = true
public_ip_name   = "pip-k8s-app-dev"
```

### Add NAT Gateway (Outbound)
```hcl
create_nat_gateway = true
nat_gateway_name   = "natgw-k8s-app-dev"
```

### Add App Gateway (Load Balancer)
```hcl
create_public_ip   = true
create_app_gateway = true
app_gateway_name   = "appgw-k8s-app-dev"
```

---

## 📤 Common Outputs

```bash
# View all networking info
terraform output pcam_network_info

# Get specific values
terraform output vnet_id
terraform output app_subnet_id
terraform output aks_subnet_id
terraform output nsg_id
terraform output public_ip_address    # If enabled
terraform output nat_gateway_public_ip # If enabled
```

---

## 🔧 Variable Reference

### Required Variables
```hcl
vnet_name                  # "vnet-dev"
vnet_address_space         # ["10.0.0.0/16"]
subnet_name                # "subnet-dev"
subnet_address_prefix      # "10.0.1.0/24"
aks_subnet_name            # "subnet-aks-dev"
aks_subnet_address_prefix  # "10.0.2.0/24"
location                   # "eastus"
resource_group_name        # "rg-k8s-app-dev"
environment                # "dev"
```

### Optional Boolean Flags
```hcl
create_nsg            = true     # Enable NSG
create_route_table    = true     # Enable routing
create_public_ip      = false    # Enable public IP
create_nat_gateway    = false    # Enable NAT Gateway
create_app_gateway    = false    # Enable App Gateway
create_private_dns_zone = false  # Enable private DNS
create_vnet_peering   = false    # Enable peering
create_nic            = false    # Enable NIC
```

### Naming Parameters
```hcl
nsg_name              = "nsg-k8s-app-dev"
route_table_name      = "rt-k8s-app-dev"
public_ip_name        = "pip-k8s-app-dev"
nat_gateway_name      = "natgw-k8s-app-dev"
app_gateway_name      = "appgw-k8s-app-dev"
```

---

## 📊 Parameters by Count (Total: 50+)

| Category | Count | Key Variables |
|----------|-------|---|
| **Core** | 4 | vnet_name, vnet_address_space, location, resource_group_name |
| **Subnets** | 4 | subnet_name, subnet_address_prefix, aks_subnet_name, aks_subnet_address_prefix |
| **NSG** | 3 | create_nsg, nsg_name, nsg_rules |
| **Route Table** | 3 | create_route_table, route_table_name, routes |
| **Public IP** | 4 | create_public_ip, public_ip_name, allocation_method, sku |
| **NIC** | 4 | create_nic, nic_name, nic_ip_allocation, private_ip_address |
| **NAT Gateway** | 3 | create_nat_gateway, nat_gateway_name, idle_timeout |
| **App Gateway** | 4 | create_app_gateway, app_gateway_name, app_gateway_sku, capacity |
| **Private DNS** | 2 | create_private_dns_zone, private_dns_zone_name |
| **VNet Peering** | 3 | create_vnet_peering, peer_vnet_id, peer_vnet_name |
| **Common** | 2 | tags, environment |
| **TOTAL** | **50+** | — |

---

## 🎯 Common Tasks

### Task: View VNet Details
```bash
terraform output vnet_id
terraform output vnet_address_space
```

### Task: Get All Subnet IDs
```bash
terraform output all_subnet_ids
# Returns: { app_subnet: "...", aks_subnet: "..." }
```

### Task: Enable NAT Gateway
1. Edit `dev.tfvars`:
   ```hcl
   create_nat_gateway = true
   ```
2. Run:
   ```bash
   terraform plan -var-file="dev.tfvars"
   terraform apply -var-file="dev.tfvars"
   ```

### Task: Check NSG Rules
```bash
terraform output nsg_id
# Use Azure CLI to check rules:
# az network nsg rule list --resource-group rg-k8s-app-dev --nsg-name nsg-k8s-app-dev
```

### Task: Get Public IP Address
```bash
terraform output public_ip_address  # If public IP created
```

---

## 🚀 Deployment Commands

```bash
# Navigate to environment
cd terraform/environments/dev

# Initialize (first time)
terraform init

# Plan
terraform plan -var-file="dev.tfvars"

# Apply
terraform apply -var-file="dev.tfvars"

# Output
terraform output
terraform output pcam_network_info

# Destroy
terraform destroy -var-file="dev.tfvars"
```

---

## 📝 Integration in main.tf

```hcl
module "pcam_networking" {
  source              = "../../PCAM"
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  location            = var.azure_region
  resource_group_name = module.resource_group.resource_group_name
  
  # Subnets
  subnet_name              = var.subnet_name
  subnet_address_prefix    = var.subnet_address_prefix
  aks_subnet_name          = var.aks_subnet_name
  aks_subnet_address_prefix = var.aks_subnet_address_prefix
  
  # Features (all optional)
  create_nsg = var.create_nsg
  create_route_table = var.create_route_table
  create_public_ip = var.create_public_ip
  create_nat_gateway = var.create_nat_gateway
  create_app_gateway = var.create_app_gateway
  create_private_dns_zone = var.create_private_dns_zone
  
  tags        = var.tags
  environment = var.environment
}
```

---

## 📄 Resources Created (Dev Default)

### Always
```
✅ azurerm_virtual_network
✅ azurerm_subnet (app)
✅ azurerm_subnet (aks)
```

### By Default (Enabled)
```
✅ azurerm_network_security_group
✅ azurerm_network_security_rule (HTTP)
✅ azurerm_network_security_rule (HTTPS)
✅ azurerm_subnet_network_security_group_association (x2)
✅ azurerm_route_table
✅ azurerm_route
✅ azurerm_subnet_route_table_association (x2)
```

### Optional (When Enabled)
```
⚪ azurerm_public_ip
⚪ azurerm_network_interface
⚪ azurerm_nat_gateway
⚪ azurerm_nat_gateway_public_ip_association
⚪ azurerm_subnet_nat_gateway_association
⚪ azurerm_application_gateway
⚪ azurerm_private_dns_zone
⚪ azurerm_private_dns_zone_virtual_network_link
⚪ azurerm_virtual_network_peering
```

---

## 💡 Best Practices

1. **Start Minimal:** Enable only what you need
2. **Use Defaults:** NSG and Route Table defaults are secure
3. **Test First:** Use dev.tfvars before staging/prod
4. **Cost Aware:** NAT Gateway costs ~$32/month
5. **Security:** Keep NSG rules restrictive
6. **Naming:** Follow naming convention for consistency

---

## ❌ Common Issues & Solutions

### Issue: Subnets overlap
**Solution:** Check address_prefix doesn't overlap with vnet_address_space or other subnets

### Issue: NSG rules not working
**Solution:** Ensure create_nsg=true and check rule priorities

### Issue: NAT Gateway not working
**Solution:** Ensure create_nat_gateway=true and check public IP is created

### Issue: Public IP not assigned
**Solution:** Check create_public_ip=true and public_ip_allocation_method

---

## 📚 Full Documentation

For complete information, see:
- `terraform/PCAM/README.md` - Full module documentation
- `terraform/PCAM/variables.tf` - All 50+ parameters
- `terraform/PCAM/networking.tf` - Resource definitions
- `terraform/environments/dev/main.tf` - Integration example

---

## ✅ Status

- **PCAM Module:** ✅ Complete
- **Environment Integration:** ✅ Complete
- **All Parameters:** ✅ 50+ implemented
- **Validation:** ✅ 0 errors
- **Documentation:** ✅ Complete
- **Ready to Deploy:** ✅ Yes

---

**Quick Links:**
- PCAM Module: `terraform/PCAM/`
- Dev Environment: `terraform/environments/dev/`
- Values File: `terraform/environments/dev/dev.tfvars`
- Module Documentation: `terraform/PCAM/README.md`
- Integration Summary: `terraform/PCAM_INTEGRATION_SUMMARY.md`
