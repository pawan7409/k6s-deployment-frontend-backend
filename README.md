# Kubernetes App Deployment - Complete Guide

A production-ready project deploying Angular frontend and Python backend applications on Kubernetes with Azure integration, CI/CD using GitHub Actions, and comprehensive monitoring.

## 📋 Table of Contents

- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Frontend Setup](#frontend-setup)
- [Backend Setup](#backend-setup)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Azure Infrastructure](#azure-infrastructure)
- [CI/CD Pipelines](#cicd-pipelines)
- [Monitoring & Logging](#monitoring--logging)
- [Troubleshooting](#troubleshooting)

## 📁 Project Structure

```
kubernetes-app-deployment/
├── frontend/                      # Angular application
│   ├── src/
│   │   ├── app/
│   │   │   ├── app.component.ts
│   │   │   ├── app.component.html
│   │   │   ├── app.service.ts
│   │   │   └── app.component.css
│   │   ├── main.ts
│   │   ├── index.html
│   │   └── styles.css
│   ├── package.json
│   ├── tsconfig.json
│   ├── angular.json
│   └── Dockerfile
│
├── backend/                       # Python Flask application
│   ├── app.py
│   ├── config.py
│   ├── azure_integration.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env.example
│
├── kubernetes/                    # K8s manifests
│   ├── 01-frontend-deployment.yaml
│   ├── 02-backend-deployment.yaml
│   ├── 03-configmap-secrets.yaml
│   ├── 04-ingress.yaml
│   └── 05-policies-hpa.yaml
│
├── azure/                         # Terraform IaC
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf
│   └── identity.tf
│
├── .github/workflows/             # CI/CD pipelines
│   ├── docker-build.yaml          # Build Docker images
│   ├── k8s-deploy.yaml            # Deploy to Kubernetes
│   ├── azure-deploy.yaml          # Deploy to Azure
│   └── tests.yaml                 # Run tests
│
└── README.md
```

## 🏗️ Architecture

### Components

1. **Frontend (Angular 17)**
   - Standalone Angular components
   - Bootstrap for styling
   - HttpClient for API communication
   - Running on port 4200

2. **Backend (Python Flask)**
   - RESTful API endpoints
   - CORS enabled for cross-origin requests
   - Azure services integration
   - Running on port 5000

3. **Kubernetes Cluster**
   - Azure Kubernetes Service (AKS)
   - 2 replicas for each microservice
   - Horizontal Pod Autoscaling (HPA)
   - Network policies for security

4. **Azure Services**
   - App Service (Backend & Frontend alternative)
   - Function App (Serverless tasks)
   - Storage Account (Data persistence)
   - Key Vault (Secrets management)
   - Container Registry (Docker images)
   - Application Insights (Monitoring)

5. **CI/CD**
   - GitHub Actions workflows
   - Automated builds on push
   - Docker image building and pushing
   - Automated Kubernetes deployments

## ✅ Prerequisites

### Local Development

- Node.js 18+
- Python 3.11+
- Docker & Docker Compose
- kubectl CLI
- Terraform (for Azure infrastructure)
- Azure CLI

### Cloud Setup

- Azure Subscription
- AKS Cluster configured
- Azure Container Registry (ACR)
- Service Principal for CI/CD

### GitHub Setup

- GitHub repository
- Secrets configured:
  - `ACR_USERNAME`
  - `ACR_PASSWORD`
  - `AZURE_CREDENTIALS` (Service Principal JSON)
  - `AZURE_RESOURCE_GROUP`
  - `AZURE_LOCATION`
  - `AKS_CLUSTER_NAME`
  - `TF_STATE_STORAGE`

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone <repository-url>
cd kubernetes-app-deployment
```

### 2. Set Up Frontend

```bash
cd frontend
npm install
npm start  # Development server at http://localhost:4200
```

### 3. Set Up Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env  # Configure as needed
python app.py  # Server at http://localhost:5000
```

### 4. Build Docker Images

```bash
# Frontend
docker build -t myregistry.azurecr.io/angular-frontend:latest ./frontend

# Backend
docker build -t myregistry.azurecr.io/python-backend:latest ./backend
```

### 5. Deploy to Kubernetes

```bash
# Apply manifests
kubectl apply -f kubernetes/01-frontend-deployment.yaml
kubectl apply -f kubernetes/02-backend-deployment.yaml
kubectl apply -f kubernetes/03-configmap-secrets.yaml
kubectl apply -f kubernetes/04-ingress.yaml
kubectl apply -f kubernetes/05-policies-hpa.yaml

# Verify deployments
kubectl get deployments
kubectl get pods
kubectl get services
```

## 📱 Frontend Setup

### Project Structure

```
frontend/
├── src/
│   ├── app/
│   │   ├── app.component.ts      # Root component
│   │   ├── app.component.html    # Template
│   │   ├── app.component.css     # Styles
│   │   └── app.service.ts        # HTTP service
│   ├── main.ts                   # Bootstrap
│   ├── index.html                # HTML entry
│   └── styles.css                # Global styles
├── package.json
├── tsconfig.json
├── angular.json
└── Dockerfile
```

### Running Locally

```bash
cd frontend
npm install
npm start
```

### Building for Production

```bash
npm run build:prod
```

### Docker Build

```bash
docker build -t angular-frontend:latest .
docker run -p 4200:4200 angular-frontend:latest
```

## 🐍 Backend Setup

### Project Structure

```
backend/
├── app.py                # Flask application
├── config.py            # Configuration
├── azure_integration.py # Azure services
├── requirements.txt     # Dependencies
├── Dockerfile
└── .env.example        # Environment template
```

### API Endpoints

- `GET /health` - Health check
- `GET /api/data` - Fetch data
- `POST /api/data` - Create data
- `GET /api/status` - API status
- `POST /api/process` - Process data
- `GET /api/info` - Application info

### Running Locally

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

### Docker Build

```bash
docker build -t python-backend:latest .
docker run -p 5000:5000 python-backend:latest
```

## ⚙️ Kubernetes Deployment

### Manifest Files

#### 1. Frontend Deployment (`01-frontend-deployment.yaml`)
- 2 replicas
- Rolling update strategy
- Resource limits: 256Mi RAM, 500m CPU
- Liveness & readiness probes

#### 2. Backend Deployment (`02-backend-deployment.yaml`)
- 2 replicas
- Health check endpoints
- ServiceAccount for Azure integration
- Config maps and secrets

#### 3. ConfigMap & Secrets (`03-configmap-secrets.yaml`)
- Azure configuration
- Database credentials
- API keys

#### 4. Ingress (`04-ingress.yaml`)
- NGINX ingress controller
- TLS/SSL support
- Route to frontend and backend

#### 5. Policies & HPA (`05-policies-hpa.yaml`)
- Network policies for security
- Auto-scaling based on CPU and memory
- Min: 2, Max: 5 (frontend), Min: 2, Max: 10 (backend)

### Deploy Commands

```bash
# Apply all manifests
kubectl apply -f kubernetes/

# Check status
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get ingress

# View logs
kubectl logs -l app=angular-frontend
kubectl logs -l app=python-backend

# Scale deployments
kubectl scale deployment angular-frontend --replicas=3
```

## ☁️ Azure Infrastructure

### Terraform Configuration

#### Resources Created

1. **Resource Group** - Container for all resources
2. **App Service Plan** - Hosting plan (Standard S1)
3. **App Services** - Backend and Frontend hosting
4. **Storage Account** - Data persistence (GRS replication)
5. **Key Vault** - Secrets management
6. **Function App** - Serverless computing (Y1 tier)
7. **Container Registry** - Docker image storage
8. **Log Analytics** - Log aggregation
9. **Application Insights** - Performance monitoring

### Deployment

```bash
cd azure

# Initialize Terraform
terraform init \
  -backend-config="storage_account_name=yourstore" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=kubernetes-app.tfstate" \
  -backend-config="resource_group_name=your-rg"

# Validate configuration
terraform validate

# Plan deployment
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# View outputs
terraform output
```

### Output Values

```json
{
  "resource_group_name": "kubernetes-app-rg",
  "app_service_backend_hostname": "kube-app-backend.azurewebsites.net",
  "app_service_frontend_hostname": "kube-app-frontend.azurewebsites.net",
  "storage_account_name": "kubeappsto",
  "container_registry_login_server": "kubeappacr.azurecr.io",
  "function_app_name": "kube-app-func"
}
```

## 🔄 CI/CD Pipelines

### GitHub Actions Workflows

#### 1. Docker Build (`docker-build.yaml`)

**Trigger:** Push to main/develop or PR

**Steps:**
- Checkout code
- Setup Docker Buildx
- Login to ACR
- Build and push Frontend image
- Build and push Backend image

**Runs on:** ubuntu-latest

#### 2. Kubernetes Deploy (`k8s-deploy.yaml`)

**Trigger:** Push to main or completion of Docker build

**Steps:**
- Checkout code
- Connect to AKS cluster
- Update deployment images
- Apply Kubernetes manifests
- Verify rollout status
- Check service status

**Runs on:** ubuntu-latest

#### 3. Azure Deploy (`azure-deploy.yaml`)

**Trigger:** Changes to `azure/` directory on main branch

**Steps:**
- Deploy infrastructure with Terraform
- Deploy to App Service
- Deploy to Function App

**Runs on:** ubuntu-latest

#### 4. Tests (`tests.yaml`)

**Trigger:** Push to main/develop or PR

**Steps:**
- Run frontend linting and build
- Run backend linting and tests
- Upload coverage to Codecov

**Runs on:** ubuntu-latest

### Setting Up GitHub Secrets

```bash
# Azure credentials (Service Principal JSON)
az ad sp create-for-rbac --name "kubernetes-app-ci" \
  --role contributor \
  --scopes /subscriptions/{subscription-id} \
  --output json

# Store as AZURE_CREDENTIALS secret

# ACR credentials
az acr credential show --name myregistry

# Store ACR_USERNAME and ACR_PASSWORD as secrets
```

## 📊 Monitoring & Logging

### Kubernetes Monitoring

```bash
# Pod metrics
kubectl top pods -n default
kubectl top nodes

# Describe pod
kubectl describe pod <pod-name>

# View events
kubectl get events -n default

# Resource usage
kubectl get resourcequotas
```

### Application Insights

Access via Azure Portal:
- Application Insights → Performance
- Live Metrics Stream
- Dependencies & Performance
- Failed requests

### Log Analytics

Query logs in Azure Portal:
```kusto
// Recent logs
AppTraces
| where TimeGenerated > ago(1h)
| project TimeGenerated, Message

// Performance data
PerformanceCounters
| where CounterName == "% Processor Time"
| summarize Avg=avg(CounterValue) by Computer
```

## 🔧 Troubleshooting

### Pod Issues

```bash
# Check pod status
kubectl get pods -o wide

# View pod logs
kubectl logs <pod-name>

# Get detailed pod info
kubectl describe pod <pod-name>

# Exec into pod
kubectl exec -it <pod-name> -- /bin/sh
```

### Service Communication

```bash
# Test service connectivity
kubectl exec -it <pod-name> -- curl http://python-backend:5000/health

# Port forward for testing
kubectl port-forward svc/python-backend 5000:5000
```

### Deployment Issues

```bash
# Check rollout status
kubectl rollout status deployment/angular-frontend

# Rollback deployment
kubectl rollout undo deployment/angular-frontend

# View deployment history
kubectl rollout history deployment/angular-frontend
```

### Azure Issues

```bash
# Check Terraform state
terraform show

# Validate Azure credentials
az account show

# Check resource group
az group show -n kubernetes-app-rg
```

## 📝 Environment Variables

### Backend (.env)

```
DEBUG=False
ENVIRONMENT=production
PORT=5000
STORAGE_ACCOUNT_NAME=your_storage_account
KEYVAULT_URL=https://your-keyvault.vault.azure.net/
APP_SERVICE_NAME=your_app_service
DATABASE_URL=your_database_connection_string
NAMESPACE=default
```

### GitHub Actions Secrets

- `ACR_USERNAME` - Azure Container Registry username
- `ACR_PASSWORD` - Azure Container Registry password
- `AZURE_CREDENTIALS` - Service Principal credentials (JSON)
- `AZURE_RESOURCE_GROUP` - Resource group name
- `AZURE_LOCATION` - Azure region (e.g., eastus)
- `AKS_CLUSTER_NAME` - AKS cluster name
- `TF_STATE_STORAGE` - Storage account for Terraform state

## 📚 Additional Resources

- [Angular Documentation](https://angular.io/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure Documentation](https://docs.microsoft.com/azure/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions](https://docs.github.com/en/actions)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 📞 Support

For issues or questions:
1. Check troubleshooting section
2. Review logs in Azure Portal
3. Open a GitHub issue

---

**Last Updated:** 2024
**Version:** 1.0.0
