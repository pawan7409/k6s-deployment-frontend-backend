# GitHub Actions CI/CD Configuration Guide

## Overview

This project uses GitHub Actions for automated:
1. Testing on every push/PR
2. Building Docker images
3. Deploying to Kubernetes
4. Deploying Azure infrastructure

## Required Secrets

Configure these in GitHub Settings → Secrets and variables → Actions:

### Docker/Registry Secrets
```
ACR_USERNAME        # Azure Container Registry username
ACR_PASSWORD        # Azure Container Registry password
```

### Azure Secrets
```
AZURE_CREDENTIALS           # Service Principal JSON
AZURE_RESOURCE_GROUP        # Resource group name
AZURE_LOCATION              # Azure region (e.g., eastus)
AKS_CLUSTER_NAME           # AKS cluster name
BACKEND_APP_SERVICE_NAME   # App Service name for backend
FRONTEND_APP_SERVICE_NAME  # App Service name for frontend
FUNCTION_APP_NAME          # Function App name
TF_STATE_STORAGE           # Storage account for Terraform state
```

## Creating Service Principal

```bash
# Login to Azure
az login

# Create Service Principal
az ad sp create-for-rbac \
  --name "kubernetes-app-ci" \
  --role Contributor \
  --scopes /subscriptions/{SUBSCRIPTION_ID} \
  --output json

# Output example:
# {
#   "appId": "...",
#   "displayName": "kubernetes-app-ci",
#   "password": "...",
#   "tenant": "..."
# }

# Use the JSON output as AZURE_CREDENTIALS secret
```

## Workflows

### 1. Tests Workflow (`tests.yaml`)

**Triggers:** 
- Push to main/develop branches
- Pull requests to main

**Jobs:**
- Test Frontend (Node.js)
- Test Backend (Python)

**Actions:**
- Install dependencies
- Run linters
- Build applications
- Run tests
- Upload coverage

**Manual Trigger:**
```bash
gh workflow run tests.yaml
```

### 2. Docker Build Workflow (`docker-build.yaml`)

**Triggers:**
- Push to main/develop with changes to frontend/backend
- Pull requests to main

**Jobs:**
- Build Frontend image
- Build Backend image
- Push to ACR

**Actions:**
- Setup Docker Buildx
- Login to ACR
- Build images with cache
- Push to registry

**Manual Trigger:**
```bash
gh workflow run docker-build.yaml
```

### 3. Kubernetes Deploy Workflow (`k8s-deploy.yaml`)

**Triggers:**
- Push to main with changes to kubernetes/
- Completion of Docker build workflow

**Jobs:**
- Connect to AKS
- Update deployment images
- Apply manifests
- Verify rollout status
- Print service info

**Rollback:**
```bash
kubectl rollout undo deployment/angular-frontend
kubectl rollout undo deployment/python-backend
```

### 4. Azure Deploy Workflow (`azure-deploy.yaml`)

**Triggers:**
- Push to main with changes to azure/

**Jobs:**
- Deploy infrastructure (Terraform)
- Deploy to App Service
- Deploy to Function App

**Terraform State:**
- Stored in Azure Storage Account
- Requires proper backend configuration

## Manual Workflow Runs

```bash
# List workflows
gh workflow list

# Run specific workflow
gh workflow run docker-build.yaml

# Run workflow with inputs
gh workflow run azure-deploy.yaml \
  -f environment=production
```

## Viewing Results

### GitHub Actions UI
1. Go to repository → Actions
2. Click on workflow run
3. View job logs in real-time

### GitHub CLI
```bash
# Watch workflow run
gh run watch <run-id>

# View workflow logs
gh run view <run-id> --log

# List recent runs
gh run list --workflow=docker-build.yaml
```

## Debugging

### Enable Debug Logging
```bash
# In workflow, set:
- name: Enable debug
  env:
    RUNNER_DEBUG: 1
  run: echo "Debug enabled"
```

### Check Secrets
```bash
# Verify secrets exist (in GitHub Actions)
- name: Check secrets
  run: |
    echo "Secrets configured:"
    echo "ACR_USERNAME: ${{ secrets.ACR_USERNAME != '' }}"
    echo "AZURE_CREDENTIALS: ${{ secrets.AZURE_CREDENTIALS != '' }}"
```

### View Deployment Logs
```bash
# After deployment
kubectl logs -l app=angular-frontend -f
kubectl logs -l app=python-backend -f
```

## Security Best Practices

1. **Use GitHub Secrets** - Never commit credentials
2. **Scope Permissions** - Create separate service principals for different environments
3. **Rotate Credentials** - Regularly update passwords/keys
4. **Audit Logs** - Monitor Actions audit log
5. **Environments** - Use GitHub Environments for staging/production

## Troubleshooting

### Docker Build Fails
- Check Docker syntax
- Verify base images are available
- Check resource limits

### Kubernetes Deploy Fails
- Verify cluster connectivity
- Check image pull permissions
- Review pod events: `kubectl describe pod <pod-name>`

### Terraform Deploy Fails
- Validate syntax: `terraform validate`
- Check state file access
- Verify service principal permissions

### Secret Not Found
- Verify secret name matches exactly
- Check organization/repository scope
- Use `${{ secrets.SECRET_NAME }}`

## Advanced Configuration

### Matrix Strategy
```yaml
strategy:
  matrix:
    node-version: [16, 18]
    python-version: [3.9, '3.11']
```

### Conditional Steps
```yaml
- name: Deploy to production
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: ./deploy.sh
```

### Environment Variables
```yaml
env:
  REGISTRY: myregistry.azurecr.io
  
jobs:
  build:
    env:
      JOB_SPECIFIC: value
```

### Artifacts
```yaml
- name: Upload coverage
  uses: actions/upload-artifact@v3
  with:
    name: coverage-report
    path: coverage/
```

## Cost Optimization

1. Use hosted runners (free for public repos)
2. Implement caching for dependencies
3. Set reasonable timeouts
4. Clean up artifacts regularly

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure CLI Reference](https://docs.microsoft.com/cli/azure/)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
