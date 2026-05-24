# Deployment Guide - Complete Infrastructure Setup

## Quick Start (5 minutes)

### 1. Prerequisites Check
```bash
# Verify Azure CLI installed
az --version

# Verify Terraform installed
terraform --version

# Verify kubectl installed (for AKS access)
kubectl version --client
```

### 2. Authenticate with Azure
```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "Your-Subscription-Name"

# Verify subscription
az account show
```

### 3. Create Service Principal for AKS
```bash
# Create Service Principal (output will show credentials)
az ad sp create-for-rbac --name "aks-dev-sp" --role "Contributor"
```
**Output:**
```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "aks-dev-sp",
  "password": "xxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### 4. Update dev.tfvars
Edit `terraform/environments/dev/dev.tfvars`:

```hcl
# Copy these values from Service Principal output
aks_service_principal_client_id     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Use appId
aks_service_principal_client_secret = "xxxxxxxxxxxxxxxxxxxxx"  # Use password
```

---

## Step-by-Step Deployment

### Step 1: Validate Terraform Configuration
```bash
cd terraform/environments/dev

# Format code
terraform fmt -recursive ../../

# Validate syntax
terraform validate
```

### Step 2: Initialize Terraform
```bash
# Initialize Terraform (downloads providers and modules)
terraform init

# Output should show:
# ✓ Terraform has been successfully configured!
```

### Step 3: Plan Deployment
```bash
# Create execution plan
terraform plan -var-file="dev.tfvars" -out=tfplan

# Review the plan output to verify:
# - 20+ resources will be created
# - No errors or warnings
# - All module outputs are available
```

### Step 4: Review Planned Resources
The plan should create approximately:

**Networking (7 resources)**
- 1 Virtual Network
- 2 Subnets
- 1 Network Security Group
- 1 Route Table
- 2 NSG Associations

**Monitoring (5 resources)**
- 1 Log Analytics Workspace
- 2 Solutions (Container Insights, Key Vault Analytics)
- 1 Application Insights
- 2 Alert Rules

**Security (1 resource)**
- 1 Key Vault (+ optional secrets)

**Container Registry (1 resource)**
- 1 Container Registry

**Kubernetes (5+ resources)**
- 1 AKS Cluster
- 2 Node Pools
- Managed resources

**Compute (5+ resources)**
- 1 App Service Plan
- 2 App Services (frontend + backend)
- 1 Function App Service Plan
- 1 Function App
- 1 Staging Slot

**Total: 25-30 resources**

### Step 5: Apply Configuration
```bash
# Apply the plan
terraform apply tfplan

# This will take 15-20 minutes
# Monitor progress in the terminal

# Upon completion, you'll see:
# Apply complete! Resources: 25 added, 0 changed, 0 destroyed.
```

### Step 6: Verify Deployment
```bash
# Get all outputs
terraform output

# Save outputs to file for reference
terraform output > deployment_outputs.txt

# Key outputs to verify:
# - aks_fqdn (AKS cluster FQDN)
# - container_registry_login_server (ACR login server)
# - key_vault_uri (Key Vault URI)
# - app_insights_instrumentation_key (for app configuration)
```

---

## Post-Deployment Configuration

### 1. Connect to AKS Cluster
```bash
# Get AKS credentials
CLUSTER_NAME=$(terraform output -raw aks_cluster_name)
RG_NAME=$(terraform output -raw resource_group_name)

az aks get-credentials \
  --resource-group $RG_NAME \
  --name $CLUSTER_NAME \
  --overwrite-existing

# Verify connection
kubectl cluster-info
kubectl get nodes
kubectl get namespaces
```

### 2. Configure Container Registry Access
```bash
# Get ACR login server
ACR_SERVER=$(terraform output -raw container_registry_login_server)

# Login to ACR
az acr login --name $(echo $ACR_SERVER | cut -d'.' -f1)

# Create docker credentials secret for AKS
kubectl create secret docker-registry acr-secret \
  --docker-server=$ACR_SERVER \
  --docker-username=<username> \
  --docker-password=<password> \
  --docker-email=admin@example.com \
  --namespace default
```

### 3. Deploy Frontend to AKS
```bash
# Create deployment manifest for frontend
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: $ACR_SERVER/frontend:latest
        ports:
        - containerPort: 4200
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
      imagePullSecrets:
      - name: acr-secret
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 4200
  type: ClusterIP
EOF
```

### 4. Deploy Backend to AKS
```bash
# Create deployment manifest for backend
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: $ACR_SERVER/backend:latest
        ports:
        - containerPort: 5000
        env:
        - name: APPLICATIONINSIGHTS_CONNECTION_STRING
          valueFrom:
            secretKeyRef:
              name: app-config
              key: app-insights-connection-string
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
      imagePullSecrets:
      - name: acr-secret
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
  - protocol: TCP
    port: 5000
    targetPort: 5000
  type: ClusterIP
EOF
```

### 5. Configure Application Settings
```bash
# Create ConfigMap for application configuration
kubectl create configmap app-config \
  --from-literal=API_URL=http://backend-service:5000 \
  --from-literal=LOG_LEVEL=INFO

# Create Secret for sensitive data
APP_INSIGHTS_KEY=$(terraform output -raw app_insights_instrumentation_key)

kubectl create secret generic app-secrets \
  --from-literal=app-insights-connection-string="InstrumentationKey=$APP_INSIGHTS_KEY"
```

### 6. Deploy NGINX Ingress
```bash
# Add NGINX Ingress repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install NGINX Ingress
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer

# Create Ingress resource
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  ingressClassName: nginx
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 5000
EOF
```

---

## Validation Checklist

```bash
# 1. Verify all pods are running
kubectl get pods --all-namespaces

# 2. Check AKS cluster status
az aks show --resource-group $RG_NAME --name $CLUSTER_NAME

# 3. Verify Ingress is configured
kubectl get ingress

# 4. Get Ingress external IP
kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller

# 5. Check Application Insights is receiving data
az monitor app-insights metrics show \
  --resource-group $RG_NAME \
  --resource-name $(terraform output -raw app_insights_name) \
  --metric requests/count

# 6. Verify Key Vault is accessible
az keyvault list --resource-group $RG_NAME

# 7. Check Container Registry images
az acr repository list --name $(echo $ACR_SERVER | cut -d'.' -f1)

# 8. Verify storage account exists
az storage account show --name $(terraform output -raw storage_account_name)
```

---

## Monitoring & Troubleshooting

### View Application Logs
```bash
# View pod logs
kubectl logs -l app=frontend -n default --tail=50
kubectl logs -l app=backend -n default --tail=50

# Stream logs in real-time
kubectl logs -l app=backend -n default -f

# View events
kubectl describe pod <pod-name> -n default
```

### Access Application Insights
```bash
# Query Application Insights data
az monitor app-insights metrics show \
  --resource-group $RG_NAME \
  --resource-name $(terraform output -raw app_insights_name) \
  --metric requests/duration

# View traces
az monitor app-insights events show \
  --app $(terraform output -raw app_insights_name) \
  --resource-group $RG_NAME \
  --type traces
```

### Verify Key Vault Secrets
```bash
# List all secrets
az keyvault secret list --vault-name $(terraform output -raw key_vault_name)

# Get specific secret
az keyvault secret show \
  --vault-name $(terraform output -raw key_vault_name) \
  --name db-connection-string
```

### Check Function App Deployment
```bash
# Get Function App info
FUNC_APP=$(terraform output -raw function_app_name)

# View logs
az functionapp log tail --resource-group $RG_NAME --name $FUNC_APP

# Trigger test function
curl https://$FUNC_APP.azurewebsites.net/api/HttpTrigger?name=Test
```

---

## Scaling Resources

### Scale AKS Nodes
```bash
# Scale default node pool
az aks scale --resource-group $RG_NAME \
  --name $CLUSTER_NAME \
  --node-count 5

# Verify scaling
kubectl get nodes
```

### Scale Kubernetes Deployments
```bash
# Manual scaling
kubectl scale deployment frontend --replicas=5
kubectl scale deployment backend --replicas=3

# Check scaling
kubectl get deployments
```

### Monitor Auto-scaling
```bash
# Watch HPA (if configured)
kubectl get hpa --watch

# View HPA metrics
kubectl describe hpa frontend
```

---

## Cleanup / Destruction

### Destroy All Resources (if needed)
```bash
# WARNING: This will delete ALL infrastructure!

cd terraform/environments/dev

# Show what will be destroyed
terraform plan -destroy -var-file="dev.tfvars"

# Destroy infrastructure
terraform destroy -var-file="dev.tfvars" -auto-approve

# Verify deletion
az group list --query "[?name=='rg-k8s-app-dev']"
```

---

## Common Issues & Solutions

### Issue: Service Principal Authentication Fails
```bash
# Solution: Verify credentials
az login --service-principal \
  -u $CLIENT_ID \
  -p $CLIENT_SECRET \
  --tenant $TENANT_ID
```

### Issue: AKS Cluster Creation Timeout
```bash
# Solution: Check Azure quotas
az vm list-usage --location eastus

# Increase quota if needed via Azure Portal
```

### Issue: Pod Cannot Pull Image from ACR
```bash
# Solution: Verify image pull secret
kubectl get secret acr-secret -o yaml

# Re-create if needed
kubectl delete secret acr-secret
kubectl create secret docker-registry acr-secret \
  --docker-server=$ACR_SERVER \
  --docker-username=<username> \
  --docker-password=<password>
```

### Issue: Application Insights Not Receiving Data
```bash
# Solution: Verify instrumentation key is set
kubectl get cm app-config -o yaml
kubectl get secret app-secrets -o yaml

# Update if needed
kubectl delete cm app-config
kubectl create configmap app-config \
  --from-literal=INSTRUMENTATION_KEY=$APP_INSIGHTS_KEY
```

---

## Performance Tuning

### Optimize AKS for Production
```bash
# Update resource limits
kubectl set resources deployment frontend \
  --limits=cpu=500m,memory=256Mi \
  --requests=cpu=100m,memory=128Mi

# Enable HPA
kubectl autoscale deployment backend \
  --min=2 --max=10 --cpu-percent=70
```

### Optimize Function App
```bash
# Update app settings for better performance
az functionapp config appsettings set \
  --name $FUNC_APP \
  --resource-group $RG_NAME \
  --settings \
    FUNCTIONS_WORKER_PROCESS_COUNT=2 \
    WEBSITE_MEMORY_LIMIT_MB=1024
```

---

## Next Steps After Deployment

1. ✅ Configure DNS pointing to Ingress external IP
2. ✅ Set up SSL/TLS certificates (Let's Encrypt or Azure Key Vault)
3. ✅ Configure CI/CD pipeline (GitHub Actions)
4. ✅ Set up backup and disaster recovery
5. ✅ Configure alerts and monitoring dashboards
6. ✅ Implement security scanning (Trivy, Snyk)
7. ✅ Set up cost monitoring and budgets

---

## Useful Commands Reference

```bash
# Terraform Commands
terraform init                          # Initialize Terraform
terraform plan -var-file="dev.tfvars"  # Plan deployment
terraform apply -var-file="dev.tfvars" # Apply changes
terraform output                        # Show outputs
terraform destroy -var-file="dev.tfvars" # Destroy resources

# Azure CLI Commands
az login                                # Authenticate
az account show                         # Show current subscription
az group list                           # List resource groups
az aks list                             # List AKS clusters
az acr list                             # List registries
az functionapp list                     # List function apps

# Kubernetes Commands
kubectl cluster-info                    # Show cluster info
kubectl get nodes                       # List nodes
kubectl get pods --all-namespaces      # List all pods
kubectl logs <pod>                      # View pod logs
kubectl describe pod <pod>              # Describe pod
kubectl apply -f <file>                # Apply manifest
kubectl delete -f <file>               # Delete resources
```

---

## Support & Documentation

- **Terraform Docs**: https://www.terraform.io/docs
- **Azure Terraform Provider**: https://registry.terraform.io/providers/hashicorp/azurerm/latest
- **AKS Documentation**: https://learn.microsoft.com/en-us/azure/aks/
- **Azure CLI Reference**: https://learn.microsoft.com/en-us/cli/azure/
- **Kubernetes Documentation**: https://kubernetes.io/docs/

---

**Deployment Complete! Your infrastructure is now ready to host your Kubernetes applications.** 🎉
