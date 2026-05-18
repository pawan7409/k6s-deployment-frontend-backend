# Terraform Architecture Diagram

**Visual Guide to Module Organization and Data Flow**

---

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                 Terraform Development Environment                    │
│                    terraform/environments/dev/                       │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
            ┌───────▼────────┐    │    ┌────────▼──────────┐
            │   provider.tf  │    │    │  dev.tfvars       │
            │ (Azure Config) │    │    │ (Variable Values) │
            └────────────────┘    │    └───────────────────┘
                                  │
                    ┌─────────────▼─────────────┐
                    │    main.tf               │
                    │ (Module Orchestration)   │
                    │ + Data Blocks            │
                    └──────────┬───────────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
        ┌───────▼────────┐ ┌──▼──────────┐  │
        │  Data Blocks   │ │ Variables   │  │
        │ (References)   │ │ (Inputs)    │  │
        │                │ │             │  │
        │ • client_config│ │ • env vars  │  │
        │ • storage_acct │ │ • resource  │  │
        └────────────────┘ │   names     │  │
                           └─────────────┘  │
                                            │
                        ┌───────────────────┘
                        │
                ┌───────▼────────┬───────────┐
                │                │           │
        ┌───────▼──────────┐ ┌───▼─────────▼────┐
        │ Module Call:     │ │ Module Call:      │
        │ resource_group   │ │ storage_account   │
        └────┬─────────────┘ └────┬──────────────┘
             │                    │
   ┌─────────▼──────────┐ ┌───────▼──────────┐
   │  RG Module         │ │ Storage Module    │
   │  (resources/)      │ │ (resources/)      │
   │                    │ │                   │
   │ • main.tf          │ │ • main.tf         │
   │ • variables.tf     │ │ • variables.tf    │
   │ • outputs.tf       │ │ • outputs.tf      │
   └─────────┬──────────┘ └───────┬───────────┘
             │                    │
        ┌────▼─────────────────────▼──┐
        │   Resource Creation         │
        │                             │
        │ • azurerm_resource_group   │
        │ • azurerm_storage_account  │
        │ • azurerm_storage_container│
        │ • null_resource "unnecessary"
        └─────────────────────────────┘
                     │
                ┌────▼────────────────┐
                │ Environment Outputs │
                │ (outputs.tf)        │
                │                     │
                │ Aggregates:         │
                │ • Module outputs    │
                │ • Data block values │
                │ • Environment info  │
                └─────────────────────┘
```

---

## 📦 Module Structure Pattern

```
┌──────────────────────────────────────────────────────┐
│            Module Template                           │
│      (resource_group or storage_account)             │
└──────────────────────────────────────────────────────┘

    Input Variables                Resources
    (variables.tf)                (main.tf)
         │                           │
         │  var.resource_group_name  │  azurerm_resource_group "rg"
         │  var.location             │  azurerm_storage_account "this"
         │  var.tags                 │  azurerm_storage_container "container"
         │  var.environment          │  null_resource "unnecessary"
         │                           │
         └───────────────┬───────────┘
                         │
                    Locals & Data
                         │
                    (main.tf locals)
                         │
                    Module Outputs
                     (outputs.tf)
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    • resource_group_id  │  • storage_account_id
    • resource_group_name│  • storage_account_name
    • resource_group_location  │  • storage_container_name
    • resource_group_info      │  • storage_account_primary_blob_endpoint
                           │  • storage_info
                           │
                    Environment Level
                         │
                    outputs.tf aggregates all
```

---

## 🔄 Data Flow: Variable to Resource

```
dev.tfvars
│
│  environment = "dev"
│  azure_region = "eastus"
│  resource_group_name = "rg-k8s-app-dev"
│  storage_account_name = "stgdevk8sapp"
│  create_unnecessary = false
│
├─────────────────────────────────────────────────────┐
│                                                     │
│  environment/dev/variables.tf                       │
│  (declares all variables and their types)           │
│                                                     │
│  variable "environment" { type = string }           │
│  variable "azure_region" { type = string }          │
│  variable "resource_group_name" { type = string }   │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  environment/dev/main.tf                            │
│  (uses variables to call modules)                   │
│                                                     │
│  module "resource_group" {                          │
│    resource_group_name = var.resource_group_name   │
│    location = var.azure_region                      │
│  }                                                  │
│                                                     │
│  module "storage_account" {                         │
│    storage_account_name = var.storage_account_name │
│    create_unnecessary = var.create_unnecessary      │
│  }                                                  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  modules/resource_group/main.tf                     │
│  (receives and uses variables)                      │
│                                                     │
│  resource "azurerm_resource_group" "rg" {           │
│    name = var.resource_group_name  ◄──────────────-│──┐
│    location = var.location                          │  │
│  }                                                  │  │
│                                                     │  │
├─────────────────────────────────────────────────────┤  │
│                                                     │  │
│  modules/storage_account/main.tf                    │  │
│  (receives and uses variables)                      │  │
│                                                     │  │
│  resource "azurerm_storage_account" "this" {        │  │
│    name = var.storage_account_name  ◄────────────-─│──┤
│  }                                                  │  │
│                                                     │  │
│  resource "null_resource" "unnecessary" {           │  │
│    count = var.create_unnecessary ? 1 : 0 ◄──────-─│──┤
│    # Only created if variable is true (false=skip)  │  │
│  }                                                  │  │
│                                                     │  │
├─────────────────────────────────────────────────────┤  │
│                                                     │  │
│  Azure Resources Created                            │  │
│                                                     │  │
│  • rg-k8s-app-dev (Resource Group)  ◄───────────────┘  │
│  • stgdevk8sapp (Storage Account)  ◄─────────────────┘
│  • dev-container (Blob Container)
│  • null_resource "unnecessary" (NOT created)
│
└────────────────────────────────────────────────────┘
```

---

## 📤 Data Block Flow: Azure → Terraform

```
Azure Cloud
│
├─ Subscriptions/Tenants
│  └─ Queried by: data "azurerm_client_config"
│     Returns: subscription_id, tenant_id, account_id, object_id
│     Exported to: environment/dev/outputs.tf
│
├─ Storage Accounts
   └─ Queried by: data "azurerm_storage_account" (conditional)
      Condition: count = var.lookup_existing_account ? 1 : 0
      Returns: id, name, primary_blob_endpoint, etc.
      Exported to: environment/dev/outputs.tf
```

---

## 🔁 Conditional Logic: Unnecessary Block

```
Variable Definition (storage_account/variables.tf):
┌─────────────────────────────────────────────┐
│ variable "create_unnecessary" {             │
│   type = bool                               │
│   default = false                           │
│   description = "..."                       │
│ }                                           │
└─────────────────────────────────────────────┘

Resource Usage (storage_account/main.tf):
┌─────────────────────────────────────────────┐
│ resource "null_resource" "unnecessary" {    │
│   count = var.create_unnecessary ? 1 : 0    │
│   triggers = { ... }                        │
│ }                                           │
└─────────────────────────────────────────────┘

              Decision Tree:
                 
        var.create_unnecessary
              │
        ┌─────┴─────┐
        │           │
       true        false
        │           │
    Count=1     Count=0
        │           │
    Create      Skip (not included in plan)
    Resource


Default Path (from dev.tfvars):
create_unnecessary = false  ──►  count = 0  ──►  Not created

Enable Path (edit dev.tfvars):
create_unnecessary = true   ──►  count = 1  ──►  Created
```

---

## 📊 Module Dependency Graph

```
environment/dev/main.tf
        │
        │  Depends On:
        │  ├─ provider.tf (provider config)
        │  ├─ variables.tf (input variables)
        │  ├─ dev.tfvars (variable values)
        │  └─ data blocks (external data)
        │
        ├─ Calls Module ─────────┐
        │                         ▼
        └─ Calls Module ─────────┐
                                  │
        ┌─────────────────────────┘
        │
        ├─► modules/resource_group
        │       ├─ depends on variables passed
        │       ├─ creates azurerm_resource_group
        │       ├─ produces outputs (id, name, location)
        │       └─ outputs used by storage_account module
        │
        └─► modules/storage_account
                ├─ depends on:
                │  ├─ variables passed
                │  └─ resource_group module outputs (for RG name)
                ├─ creates:
                │  ├─ azurerm_storage_account
                │  ├─ azurerm_storage_container
                │  └─ null_resource "unnecessary" (conditional)
                └─ produces outputs (account id, name, container name)

        All outputs aggregated in:
        environment/dev/outputs.tf
```

---

## 🔀 File Dependencies

```
dev.tfvars (values)
    │
    ▼
variables.tf (declarations)
    │
    ▼
main.tf (orchestration)
    │
    ├──────────────┬─────────────────┐
    │              │                 │
    ▼              ▼                 ▼
provider.tf   (Module: RG)      (Module: Storage)
    │              │                 │
    │          variables.tf      variables.tf
    │              │                 │
    │          main.tf            main.tf
    │              │                 │
    │          outputs.tf        outputs.tf
    │              │                 │
    └──────────────┴─────────────────┘
                   │
                   ▼
            outputs.tf (aggregation)
                   │
                   ▼
            terraform output (display)
```

---

## 🎯 Deployment State Diagram

```
Initial State
    │
    ├─ Terraform files ✓
    ├─ Variable files ✓
    ├─ Modules ✓
    └─ Documentation ✓
            │
            ▼
    terraform init
    │
    ├─ Download provider plugin ✓
    ├─ Create .terraform directory ✓
    ├─ Initialize backend ✓
    └─ Validate structure ✓
            │
            ▼
    terraform plan -var-file="dev.tfvars"
    │
    ├─ Read dev.tfvars values ✓
    ├─ Read all variables ✓
    ├─ Call modules with variables ✓
    ├─ Execute data blocks ✓
    ├─ Calculate resource changes ✓
    └─ Generate execution plan ✓
            │
            ▼
    Review Plan Output
    │
    ├─ Resource Group will be created ✓
    ├─ Storage Account will be created ✓
    ├─ Storage Container will be created ✓
    ├─ null_resource "unnecessary" will NOT be created (count=0) ✓
    └─ Data blocks will fetch subscription info ✓
            │
            ▼
    terraform apply -var-file="dev.tfvars"
    │
    ├─ Authenticate to Azure ✓
    ├─ Create resource group ✓
    ├─ Create storage account ✓
    ├─ Create blob container ✓
    ├─ Fetch data block info ✓
    ├─ Save state to tfstate ✓
    └─ Display outputs ✓
            │
            ▼
    terraform output
    │
    ├─ subscription_id: (displayed)
    ├─ tenant_id: (displayed)
    ├─ resource_group_id: (displayed)
    ├─ resource_group_name: (displayed)
    ├─ storage_account_id: (displayed)
    ├─ storage_account_name: (displayed)
    ├─ storage_container_name: (displayed)
    └─ existing_storage_account_info: (displayed)
            │
            ▼
    ✅ Infrastructure Deployed
```

---

## 📋 Component Checklist

```
✅ Folder Structure
   ✅ terraform/
      ✅ modules/
         ✅ resource_group/
            ✅ main.tf
            ✅ variables.tf
            ✅ outputs.tf
         ✅ storage_account/
            ✅ main.tf
            ✅ variables.tf
            ✅ outputs.tf
      ✅ environments/
         ✅ dev/
            ✅ main.tf (with data blocks)
            ✅ provider.tf
            ✅ variables.tf
            ✅ outputs.tf
            ✅ dev.tfvars

✅ Key Features
   ✅ Data Blocks
      ✅ azurerm_client_config
      ✅ azurerm_storage_account (conditional)
   ✅ Unnecessary Blocks
      ✅ null_resource "unnecessary" (conditional)
   ✅ Outputs
      ✅ Module outputs (6 per module)
      ✅ Environment outputs (10+)

✅ Documentation
   ✅ README.md
   ✅ REQUIREMENTS_CHECKLIST.md
   ✅ SUMMARY.md
   ✅ CHANGELOG.md
   ✅ ARCHITECTURE.md (this file)

✅ Validation
   ✅ All files error-free
   ✅ All data blocks working
   ✅ All modules callable
   ✅ All outputs defined
```

---

## Legend

```
▼  = Data flows downward
◄  = Reference direction
──►= Dependency direction
?  = Conditional branch
✓  = Completed/Validated
✅ = Fulfilled requirement
```
