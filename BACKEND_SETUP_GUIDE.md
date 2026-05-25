# GitHub Workflows Troubleshooting & Setup Guide

## Problem: Workflows Not Showing in GitHub

Your workflows are committed but not running/showing because:
1. **Workflows are on `features/k8sdeployment` branch** 
2. **But they're configured to trigger on `main` branch**
3. **GitHub needs workflows to exist on the branch they monitor**

---

## Solution 1: Merge features/k8sdeployment to main ✅ RECOMMENDED

This is the cleanest approach - bring all changes to main branch.

```bash
# Check current branch
git branch

# Switch to main
git checkout main

# Pull latest from main
git pull origin main

# Merge features/k8sdeployment into main
git merge features/k8sdeployment

# Push to GitHub
git push origin main
```

After merging:
- ✅ Workflows will appear in GitHub Actions tab
- ✅ Workflows will start running on main branch
- ✅ All automation will work

---

## Solution 2: Update Workflows to Trigger on Feature Branch

If you want to test workflows without merging to main:

**In each workflow file** - Change the `on:` section:

```yaml
on:
  push:
    branches:
      - main
      - features/k8sdeployment  # ADD THIS LINE
      - develop
  workflow_dispatch:
```

This allows workflows to run on both `main` AND `features/k8sdeployment` branches.

---

## Branch Overview

| Branch | Status | Workflows Monitored |
|--------|--------|-------------------|
| `main` | Remote branch | ✅ All workflows |
| `features/k8sdeployment` | Current branch | ❌ Workflows not visible here |
| `develop` | Does not exist | N/A |

---

## Complete Merge Steps

### Step 1: Prepare main branch
```bash
git checkout main
git pull origin main
```

### Step 2: Merge feature branch
```bash
git merge features/k8sdeployment --no-ff
```

### Step 3: Push to GitHub
```bash
git push origin main
```

### Step 4: Verify workflows
- Go to: GitHub → Actions tab
- You should see all 5 workflows listed:
  - ✅ Deploy to Azure Services
  - ✅ Run Tests  
  - ✅ Build and Deploy
  - ✅ Build and Push Docker Images
  - ✅ Deploy to Kubernetes

### Step 5: Check workflow status
- Click on each workflow
- Recent pushes should show workflow executions
- Green checkmarks = successful
- Red X = failures
- Yellow dots = running

---

## Verify Workflows After Merge

```bash
# After merging and pushing
git log --oneline -10

# Should show your commits on main
# 1234567 fix: Restore SERVICE_PRINCIPAL auth...
# abcdef1 Merge branch 'features/k8sdeployment'...
```

---

## Backend Storage Setup

### Terraform Configuration Created ✅

**New Files:**
- `terraform/environments/dev/backend-storage.tf` - Backend storage infrastructure
- **Updated:** `terraform/environments/dev/variables.tf` - New backend storage variables
- **Updated:** `terraform/environments/dev/dev.tfvars` - Backend storage values

### What Gets Created:

1. **Separate Resource Group:**
   - Name: `rg-backend-storage-dev`
   - Location: Same as main infrastructure

2. **Storage Account:**
   - Name: `stbackenddev`
   - Type: Standard LRS (Locally Redundant)
   - Containers:
     - `backend-data` - Main data container
     - `backend-data-logs` - Logs container
     - `backend-data-uploads` - Uploads container

3. **Network Rules:**
   - Private by default
   - Accessible from AKS subnet
   - Azure services allowed

### Deploy Backend Storage

```bash
# Navigate to Terraform directory
cd terraform/environments/dev

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan the deployment
terraform plan -var-file="dev.tfvars"

# Apply the configuration
terraform apply -var-file="dev.tfvars"

# Get outputs (connection strings, keys, etc.)
terraform output
```

### Get Connection Details

After deployment:

```bash
# Get storage account name
terraform output backend_storage_account_name

# Get container name
terraform output backend_container_name

# Get connection string (for backend app)
terraform output backend_storage_connection_string

# Get primary access key
terraform output backend_storage_account_key
```

### Use in Backend Application

Update your backend configuration:

```python
# backend/config.py
import os
from azure.storage.blob import BlobServiceClient

# Get from Terraform outputs
STORAGE_ACCOUNT_NAME = os.getenv("BACKEND_STORAGE_ACCOUNT")
CONTAINER_NAME = os.getenv("BACKEND_CONTAINER_NAME")
CONNECTION_STRING = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Initialize blob client
blob_service_client = BlobServiceClient.from_connection_string(CONNECTION_STRING)
container_client = blob_service_client.get_container_client(CONTAINER_NAME)

# Use for uploads
def upload_file(file_path, blob_name):
    with open(file_path, "rb") as data:
        container_client.upload_blob(blob_name, data)

def download_file(blob_name, local_path):
    blob_client = container_client.get_blob_client(blob_name)
    with open(local_path, "wb") as download_file:
        download_file.write(blob_client.download_blob().readall())
```

---

## Environment Variables to Set

After Terraform deployment, set these in your CI/CD or local environment:

```bash
# Storage Account
BACKEND_STORAGE_ACCOUNT=stbackenddev
BACKEND_CONTAINER_NAME=backend-data
AZURE_STORAGE_CONNECTION_STRING=<from terraform output>
AZURE_STORAGE_ACCOUNT_KEY=<from terraform output>

# If using Blob Storage directly
AZURE_STORAGE_ACCOUNT_URL=https://stbackenddev.blob.core.windows.net/

# Resource Group
BACKEND_RESOURCE_GROUP=rg-backend-storage-dev
```

---

## Next Steps

### Immediate Actions:
1. ✅ Merge `features/k8sdeployment` → `main`
2. ✅ Verify workflows appear in GitHub Actions
3. ✅ Run Terraform to create backend storage

### Optional:
- Configure GitHub secrets with backend storage details
- Update application code to use storage account
- Set up monitoring/alerts for storage account
- Enable soft delete on blobs for protection

---

## Troubleshooting

### Workflows still not showing after merge?
- Clear browser cache (Ctrl+F5 on GitHub)
- Check that .github/workflows/ folder exists on main
- Verify YAML syntax is valid (no indentation errors)

### Terraform apply fails?
- Check Azure credentials are configured
- Verify subscription ID and tenant ID
- Ensure resource group names are unique
- Check storage account name is globally unique

### Can't merge branches?
```bash
# If merge conflicts, resolve them:
git merge features/k8sdeployment
# Fix conflicts in files
git add .
git commit -m "Merge feature branch with resolved conflicts"
git push origin main
```

---

## Quick Reference

```bash
# Current situation
git branch          # Shows you're on features/k8sdeployment

# To merge everything to main
git checkout main
git pull origin main
git merge features/k8sdeployment
git push origin main

# After push, workflows will be visible!
```

---

**Status:** 
- ✅ Backend storage Terraform created
- ✅ Configuration ready to deploy
- ⏳ Waiting on merge to main for workflows to show
