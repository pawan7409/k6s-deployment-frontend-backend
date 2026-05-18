# Terraform Infrastructure as Code - Modular Design

## Overview
This Terraform codebase uses a **modular architecture** with environment-specific configurations. Each module encapsulates a specific Azure resource or group of resources, promoting reusability and maintainability.

## Directory Structure

```
terraform/
├── modules/                          # Reusable infrastructure modules
│   ├── resource_group/              # Creates Azure Resource Group
│   │   ├── main.tf                  # Resource definitions
│   │   ├── variables.tf             # Input variables
│   │   └── outputs.tf               # Module outputs
│   ├── storage_account/             # Creates Storage Account & Container
│   │   ├── main.tf                  # Resource definitions + unnecessary block demo
│   │   ├── variables.tf             # Input variables
│   │   └── outputs.tf               # Module outputs
│   ├── aks/                         # (Empty - for future AKS cluster)
│   ├── container_registry/          # (Empty - for future ACR)
│   ├── function_app/                # (Empty - for future Azure Functions)
│   ├── app_service/                 # (Empty - for future App Service)
│   └── network/                     # (Empty - for future networking)
│
├── environments/                     # Environment-specific configurations
│   ├── dev/                         # Development environment
│   │   ├── main.tf                  # Environment-level resource orchestration
│   │   ├── provider.tf              # Provider configuration
│   │   ├── variables.tf             # Environment variables
│   │   ├── outputs.tf               # Environment outputs (aggregates module outputs)
│   │   └── dev.tfvars               # Variable values for dev environment
│   ├── staging/                     # Staging environment (future)
│   └── prod/                        # Production environment (future)
│
└── README.md                         # This file
```

## Key Concepts Implemented

### 1. **Modular Design**
Each resource type (or related group) is encapsulated in its own module:
- **Input variables** (`variables.tf`) define what the module accepts
- **Resources** (`main.tf`) define what gets created
- **Outputs** (`outputs.tf`) expose module data to other modules or the root configuration

**Example:** The `storage_account` module takes variables like `storage_account_name`, `location`, and outputs `storage_account_id`, `storage_container_name`.

### 2. **Environment-Specific Configuration**
Each environment (dev, staging, prod) has:
- Its own `.tfvars` file with environment-specific values
- A root `main.tf` that **calls modules** with environment values
- Input `variables.tf` defining accepted parameters
- Output `outputs.tf` aggregating module outputs for visibility

**Example:** `terraform/environments/dev/dev.tfvars` sets `environment = "dev"`, `azure_region = "eastus"`, etc.

### 3. **Data Blocks (Referencing Existing Resources)**
Data blocks allow Terraform to **query existing infrastructure** without creating it:

```hcl
data "azurerm_client_config" "current" {}
# Reads current Azure subscription/tenant info

data "azurerm_storage_account" "existing" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  count               = var.lookup_existing_account ? 1 : 0
}
# Optionally looks up an existing storage account
```

### 4. **Unnecessary Block (Conditional Resource)**
A demonstration of controlling resource creation with a boolean flag:

```hcl
resource "null_resource" "unnecessary" {
  count = var.create_unnecessary ? 1 : 0
  # This resource is only created if create_unnecessary = true
}
```

This shows how to:
- Use conditional logic (`count = condition ? 1 : 0`)
- Include or exclude resources based on flags
- Keep unused/example resources in code without deploying them by default

## How to Run

### Prerequisites
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated: `az login`

### 1. Initialize Terraform (first time only)
```bash
cd terraform/environments/dev
terraform init
```

### 2. Validate Configuration
```bash
terraform validate
```

### 3. Format Check
```bash
terraform fmt -check
```

### 4. Plan Deployment
```bash
terraform plan -var-file="dev.tfvars"
```
Review the output to see what resources will be created/modified/destroyed.

### 5. Apply Configuration
```bash
terraform apply -var-file="dev.tfvars"
```
When prompted, type `yes` to confirm and deploy.

### 6. View Outputs
After apply completes, view exported values:
```bash
terraform output
```

### 7. Destroy Resources (cleanup)
```bash
terraform destroy -var-file="dev.tfvars"
```

## File Descriptions

### `dev.tfvars`
Contains **variable values** for the development environment:
- Environment name, Azure region
- Resource naming conventions
- Resource group, storage account, and container names
- Tags for resource management

Example:
```hcl
environment              = "dev"
azure_region             = "eastus"
resource_group_name      = "rg-k8s-app-dev"
storage_account_name     = "stgdevk8sapp"
container_name           = "dev-container"
```

### `main.tf` (Environment Level)
Calls modules and orchestrates infrastructure:
- Declares required providers and versions
- Includes data blocks (Azure client config, existing resources)
- Calls `resource_group` module to create RG
- Calls `storage_account` module, passing RG output as input

### `variables.tf` (Environment Level)
Declares all variables used in `main.tf` and passed to modules.

### `outputs.tf` (Environment Level)
Aggregates outputs from all modules for:
- Visibility (e.g., see IDs, names, endpoints in `terraform output`)
- Cross-stack references (e.g., if deploying to multiple environments)
- CI/CD pipelines (to extract resource IDs for further automation)

## Module Outputs Example

### Resource Group Module
Exports:
- `resource_group_id`: The RG ID
- `resource_group_name`: The RG name
- `resource_group_location`: Region
- `resource_group_info`: Local value with full info

### Storage Account Module
Exports:
- `storage_account_id`: Storage account ID
- `storage_account_name`: Storage account name
- `storage_account_primary_blob_endpoint`: Blob endpoint URL
- `storage_container_name`: Container name
- `storage_info`: Local value with ID and name

### Dev Environment (Root)
Aggregates all module outputs PLUS:
- `subscription_id`: Azure subscription (from data block)
- `tenant_id`: Azure tenant (from data block)
- `existing_storage_account_info`: Optional reference to existing account

## Notes & Best Practices

1. **Always use `.tfvars` files** for environment-specific values, not hardcoded in `.tf` files.
2. **Use `count` or `for_each`** to conditionally create resources or reference data.
3. **Data blocks are safe** — they read existing resources, never create them.
4. **Unnecessary/demo blocks** (like the `null_resource`) help document patterns but should default to disabled.
5. **Always validate and plan** before applying: `terraform validate && terraform plan`
6. **Use descriptive output names** to make automation and debugging easier.
7. **Tag all resources** for cost tracking and organization (see `tags` in `dev.tfvars`).

## Extending to Other Environments

To deploy to **staging** or **prod**:
1. Copy `terraform/environments/dev/` to `terraform/environments/staging/` or `prod/`
2. Update the `.tfvars` file with environment-specific values
3. Run the same init/plan/apply commands from the new environment directory

Example:
```bash
cd terraform/environments/staging
terraform init
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

## Troubleshooting

- **"No declaration found for var.xxx"**: Check that `variables.tf` declares the variable and `main.tf` (or module) references it correctly.
- **"Resource not found"**: Ensure you ran `terraform apply` successfully. Check `terraform.tfstate` or `terraform output`.
- **Provider authentication error**: Run `az login` and ensure Azure CLI is configured.
- **Module path errors**: Verify relative paths in `source = "../../modules/..."` match your directory structure.

## References

- [Terraform Modules Documentation](https://www.terraform.io/docs/modules)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Data Sources](https://www.terraform.io/docs/language/data-sources)
