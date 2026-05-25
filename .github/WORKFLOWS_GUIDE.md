# GitHub Workflows Guide

This document explains all GitHub Actions workflows and how to trigger them.

## Workflows Overview

### 1. **azure-deploy.yaml** ✅ Fixed
**Purpose:** Deploy infrastructure to Azure using Terraform, deploy to App Services and Azure Functions

**Triggers:**
- **Automatic (Push):** Triggers when changes are pushed to `azure/**` folder on `main` or `features/k8sdeployment` branches
- **Manual (workflow_dispatch):** Can be triggered manually from Actions tab with options:
  - Environment: `production` | `staging` | `development`
  - Apply Terraform: `true` | `false`

**Required Secrets:**
- `AZURE_CLIENT_ID` - Service Principal Client ID
- `AZURE_TENANT_ID` - Azure Tenant ID
- `AZURE_SUBSCRIPTION_ID` - Azure Subscription ID
- `TF_STATE_STORAGE` - Storage account for Terraform state
- `AZURE_RESOURCE_GROUP` - Resource Group name
- `AZURE_LOCATION` - Azure region
- `BACKEND_APP_SERVICE_NAME` - Backend App Service name
- `FRONTEND_APP_SERVICE_NAME` - Frontend App Service name
- `FUNCTION_APP_NAME` - Function App name

**How to Run Manually:**
1. Go to GitHub repo → Actions tab
2. Select "Deploy to Azure Services" workflow
3. Click "Run workflow" → Select environment → Click "Run workflow"

---

### 2. **tests.yaml** ✅ Fixed
**Purpose:** Run frontend and backend tests

**Triggers:**
- **Automatic (Push):** On push to `main` or `develop` branches
- **Automatic (PR):** On pull requests to `main`

**Jobs:**
- `test-frontend` - Runs Angular linting and build
- `test-backend` - Runs Python tests with coverage

**Fix Applied:** Removed invalid `cache-dependency-path` to fix npm cache error

---

### 3. **build-deploy.yml** ✅ Fixed
**Purpose:** Build frontend and backend applications

**Triggers:**
- **Automatic (Push):** On push to `main` or `develop` branches
- **Automatic (PR):** On pull requests to `main`
- **Manual (workflow_dispatch):** Can be triggered manually

**Jobs:**
- `build-frontend` - Builds Angular application
- `build-backend` - Builds Python application

**Fix Applied:** Removed invalid `cache-dependency-path` to fix npm cache error

---

### 4. **docker-build.yaml** ✅
**Purpose:** Build and push Docker images to Azure Container Registry

**Triggers:**
- **Automatic (Push):** On push to `main` or `develop` branches when `frontend/**`, `backend/**`, or `.github/workflows/docker-build.yaml` changes
- **Automatic (PR):** On pull requests to `main`

**Images Built:**
- `myregistry.azurecr.io/angular-frontend:tag`
- `myregistry.azurecr.io/python-backend:tag`

**Required Secrets:**
- `ACR_USERNAME` - Azure Container Registry username
- `ACR_PASSWORD` - Azure Container Registry password

---

### 5. **k8s-deploy.yaml** ✅
**Purpose:** Deploy applications to Kubernetes (AKS)

**Triggers:**
- **Automatic (Push):** On push to `main` when `kubernetes/**` or `.github/workflows/k8s-deploy.yaml` changes
- **Automatic (workflow_run):** After "Build and Push Docker Images" workflow completes successfully
- **Manual (workflow_dispatch):** Can be triggered manually

**Required Secrets:**
- `AZURE_RESOURCE_GROUP` - Resource Group name
- `AKS_CLUSTER_NAME` - AKS cluster name

**Deployments:**
- Updates image references in Kubernetes deployments
- Applies all Kubernetes manifests
- Verifies rollout status

---

## Workflow Status Badges

Add these badges to your README.md to display workflow status:

```markdown
![Azure Deploy](https://github.com/YOUR_ORG/YOUR_REPO/workflows/Deploy%20to%20Azure%20Services/badge.svg)
![Tests](https://github.com/YOUR_ORG/YOUR_REPO/workflows/Run%20Tests/badge.svg)
![Build](https://github.com/YOUR_ORG/YOUR_REPO/workflows/Build%20and%20Deploy/badge.svg)
![Docker](https://github.com/YOUR_ORG/YOUR_REPO/workflows/Build%20and%20Push%20Docker%20Images/badge.svg)
![K8s Deploy](https://github.com/YOUR_ORG/YOUR_REPO/workflows/Deploy%20to%20Kubernetes/badge.svg)
```

---

## Troubleshooting

### Azure Login Failures
**Error:** `Not all values are present. Ensure 'client-id' and 'tenant-id' are supplied`
- **Solution:** Ensure all three secrets are configured: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`

### NPM Cache Errors
**Error:** `Some specified paths were not resolved, unable to cache dependencies`
- **Solution:** The cache doesn't require the package-lock.json path. Using just `cache: 'npm'` works better

### Manual Trigger Not Showing
**Issue:** Can't see "Run workflow" button
- **Solution:** 
  1. Check that `workflow_dispatch:` is in the `on:` section
  2. Go to Actions tab
  3. Select the workflow on the left
  4. Click "Run workflow" button

---

## Secrets Setup Instructions

1. Go to GitHub Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each secret with its value
4. For SERVICE_PRINCIPAL auth in Azure, use:
   - Client ID from: `az ad sp list --query "[?appDisplayName=='your-app-name'].appId"`
   - Tenant ID from: `az account show --query tenantId`
   - Subscription ID from: `az account show --query id`

---

## Recent Fixes Applied

✅ **azure-deploy.yaml**
- Fixed SERVICE_PRINCIPAL authentication (was using deprecated `creds:`)
- Added manual trigger support with environment selection
- Added comprehensive documentation and required secrets list

✅ **tests.yaml & build-deploy.yml**
- Fixed npm cache error by removing invalid `cache-dependency-path`
- Cache now uses default npm cache directory

---

## Notes

- All workflows use Ubuntu runners (`ubuntu-latest`)
- Node.js version: 18.x
- Python version: 3.11
- Terraform version: 1.5.0
- All paths are relative to repository root
