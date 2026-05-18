# Kubernetes App Deployment - Setup Scripts

## Quick Start Script

```bash
#!/bin/bash

# setup.sh - Initialize project

echo "🚀 Kubernetes App Deployment - Setup Script"

# Check prerequisites
echo "✓ Checking prerequisites..."
command -v node &> /dev/null || { echo "Node.js not found"; exit 1; }
command -v python &> /dev/null || { echo "Python not found"; exit 1; }
command -v docker &> /dev/null || { echo "Docker not found"; exit 1; }
command -v kubectl &> /dev/null || { echo "kubectl not found"; exit 1; }

# Setup Frontend
echo "📦 Setting up Frontend..."
cd frontend
npm install
cd ..

# Setup Backend
echo "🐍 Setting up Backend..."
cd backend
python -m venv venv
source venv/bin/activate  # or: venv\Scripts\activate on Windows
pip install -r requirements.txt
cd ..

echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Configure .env files"
echo "2. Build Docker images: ./build.sh"
echo "3. Deploy to Kubernetes: ./deploy.sh"
```

## Build Script

```bash
#!/bin/bash

# build.sh - Build Docker images

echo "🐳 Building Docker images..."

REGISTRY="${REGISTRY:-myregistry.azurecr.io}"
TAG="${TAG:-latest}"

echo "Building Frontend..."
docker build -t $REGISTRY/angular-frontend:$TAG ./frontend

echo "Building Backend..."
docker build -t $REGISTRY/python-backend:$TAG ./backend

echo "✅ Build complete!"
```

## Deploy Script

```bash
#!/bin/bash

# deploy.sh - Deploy to Kubernetes

echo "🚀 Deploying to Kubernetes..."

NAMESPACE="default"

echo "Applying configuration..."
kubectl apply -f kubernetes/01-frontend-deployment.yaml
kubectl apply -f kubernetes/02-backend-deployment.yaml
kubectl apply -f kubernetes/03-configmap-secrets.yaml
kubectl apply -f kubernetes/04-ingress.yaml
kubectl apply -f kubernetes/05-policies-hpa.yaml

echo "Waiting for deployments..."
kubectl rollout status deployment/angular-frontend -n $NAMESPACE
kubectl rollout status deployment/python-backend -n $NAMESPACE

echo "✅ Deployment complete!"
echo ""
echo "Services:"
kubectl get services -n $NAMESPACE
```

## Local Development

```bash
#!/bin/bash

# dev.sh - Start local development environment

echo "🏃 Starting development environment..."

# Start Docker Compose
docker-compose up -d

echo "✅ Services started!"
echo ""
echo "URLs:"
echo "Frontend: http://localhost:4200"
echo "Backend:  http://localhost:5000"
echo "API Docs: http://localhost:5000/api/info"
```

## Cleanup Script

```bash
#!/bin/bash

# cleanup.sh - Clean up resources

echo "🧹 Cleaning up resources..."

# Remove Kubernetes resources
kubectl delete -f kubernetes/ --ignore-not-found=true

# Stop Docker Compose
docker-compose down

# Remove Docker images (optional)
# docker rmi myregistry.azurecr.io/angular-frontend:latest
# docker rmi myregistry.azurecr.io/python-backend:latest

echo "✅ Cleanup complete!"
```

## Environment Setup

```bash
#!/bin/bash

# setup-env.sh - Initialize environment

echo "📝 Setting up environment..."

# Backend
cd backend
cp .env.example .env
echo "✓ Backend .env created - configure it!"

cd ../azure
cp terraform.tfvars.example terraform.tfvars
echo "✓ Terraform variables created - configure them!"

echo "✅ Environment setup complete!"
```

## How to Use

1. **Make scripts executable:**
   ```bash
   chmod +x setup.sh build.sh deploy.sh dev.sh cleanup.sh
   ```

2. **Run setup:**
   ```bash
   ./setup.sh
   ```

3. **Start local development:**
   ```bash
   ./dev.sh
   ```

4. **Build Docker images:**
   ```bash
   ./build.sh
   ```

5. **Deploy to Kubernetes:**
   ```bash
   ./deploy.sh
   ```
