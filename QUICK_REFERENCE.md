# Quick Reference Commands

## Frontend Commands

```bash
# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build:prod

# Run tests
npm test

# Build Docker image
docker build -t angular-frontend:latest ./frontend
```

## Backend Commands

```bash
# Create virtual environment
python -m venv venv

# Activate environment (Linux/Mac)
source venv/bin/activate

# Activate environment (Windows)
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run Flask server
python app.py

# Run tests
pytest --cov=.

# Build Docker image
docker build -t python-backend:latest ./backend
```

## Docker Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Build images
docker-compose build

# Login to ACR
docker login myregistry.azurecr.io

# Push images
docker push myregistry.azurecr.io/angular-frontend:latest
docker push myregistry.azurecr.io/python-backend:latest
```

## Kubernetes Commands

```bash
# Apply manifests
kubectl apply -f kubernetes/

# Check deployments
kubectl get deployments

# Check pods
kubectl get pods

# Check services
kubectl get services

# Check ingress
kubectl get ingress

# View logs
kubectl logs -l app=angular-frontend
kubectl logs -l app=python-backend

# Port forward
kubectl port-forward svc/python-backend 5000:5000

# Scale deployment
kubectl scale deployment angular-frontend --replicas=3

# Rollback deployment
kubectl rollout undo deployment/angular-frontend

# Get detailed info
kubectl describe pod <pod-name>
kubectl describe deployment angular-frontend
```

## Terraform Commands

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan deployment
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# View outputs
terraform output

# Destroy resources
terraform destroy
```

## Azure CLI Commands

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription <subscription-id>

# Create resource group
az group create -n kubernetes-app-rg -l eastus

# Get AKS credentials
az aks get-credentials -n <cluster-name> -g <resource-group>

# Get ACR credentials
az acr credential show -n <registry-name>

# Create service principal
az ad sp create-for-rbac --name "kubernetes-app-ci" \
  --role Contributor \
  --scopes /subscriptions/<subscription-id>

# List resources
az resource list -g kubernetes-app-rg --output table
```

## GitHub Commands

```bash
# List workflows
gh workflow list

# Run workflow
gh workflow run docker-build.yaml

# View runs
gh run list

# Watch run
gh run watch <run-id>

# View logs
gh run view <run-id> --log
```

## Useful Debugging Commands

```bash
# Check current context
kubectl config current-context

# List contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context-name>

# Get events
kubectl get events -n default

# View resource usage
kubectl top nodes
kubectl top pods

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/bash

# Stream logs
kubectl logs -f -l app=angular-frontend

# Get all resources
kubectl get all -n default
```

## Common Issues & Solutions

```bash
# Pod not starting - check logs
kubectl logs <pod-name>

# Image pull error - check secrets
kubectl get secrets
kubectl describe secret <secret-name>

# Connection refused - check service
kubectl get svc
kubectl describe svc <service-name>

# Stuck in pending - check resources
kubectl describe node
kubectl top nodes

# Reset local Kubernetes
docker system prune -a
minikube delete
minikube start
```

## Monitoring Commands

```bash
# Get pod metrics
kubectl top pods

# Get node metrics
kubectl top nodes

# View resource requests/limits
kubectl describe node <node-name>

# Check HPA status
kubectl get hpa
kubectl describe hpa angular-frontend-hpa

# View deployment history
kubectl rollout history deployment/angular-frontend

# Get detailed pod info
kubectl get pods -o wide
```
