# 📑 PROJECT INDEX & NAVIGATION GUIDE

Welcome to the Kubernetes App Deployment project! This index helps you navigate all files and resources.

---

## 🎯 START HERE

### For New Users
1. **[PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)** - Overview of complete project ⭐
2. **[README.md](./README.md)** - Full documentation & setup guide
3. **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - Common commands

### For Quick Setup
```bash
# Windows
./setup.bat

# Linux/Mac
chmod +x setup.sh
./setup.sh
```

---

## 📂 PROJECT STRUCTURE

### Frontend Application
- **[frontend/](./frontend/)** - Angular 17 application
  - `package.json` - Dependencies
  - `src/app/app.component.ts` - Main component
  - `src/app/app.service.ts` - HTTP service
  - `Dockerfile` - Container configuration
  - **[FRONTEND_GUIDE.md](./frontend/FRONTEND_GUIDE.md)** - Development guide

### Backend Application
- **[backend/](./backend/)** - Python Flask API
  - `app.py` - Flask application
  - `config.py` - Configuration management
  - `azure_integration.py` - Azure services
  - `requirements.txt` - Dependencies
  - `Dockerfile` - Container configuration
  - **[BACKEND_GUIDE.md](./backend/BACKEND_GUIDE.md)** - Development guide

### Kubernetes Configuration
- **[kubernetes/](./kubernetes/)** - K8s manifests
  - `01-frontend-deployment.yaml` - Frontend deployment
  - `02-backend-deployment.yaml` - Backend deployment
  - `03-configmap-secrets.yaml` - Configuration & secrets
  - `04-ingress.yaml` - Ingress routing
  - `05-policies-hpa.yaml` - Security & autoscaling

### Azure Infrastructure
- **[azure/](./azure/)** - Terraform IaC
  - `main.tf` - Main resources
  - `variables.tf` - Input variables
  - `outputs.tf` - Output values
  - `backend.tf` - State backend
  - `identity.tf` - Azure identities

### CI/CD Pipelines
- **[.github/workflows/](./.github/workflows/)** - GitHub Actions
  - `docker-build.yaml` - Build Docker images
  - `k8s-deploy.yaml` - Deploy to Kubernetes
  - `azure-deploy.yaml` - Deploy Azure resources
  - `tests.yaml` - Run tests
  - **[CICD_GUIDE.md](./CICD_GUIDE.md)** - Configuration guide

### Configuration Files
- `docker-compose.yml` - Local development environment
- `nginx.conf` - NGINX reverse proxy config
- `.gitignore` - Git ignore patterns

### Setup Scripts
- `setup.sh` - Linux/Mac setup
- `setup.bat` - Windows setup

---

## 📚 DOCUMENTATION

### Main Documentation
| Document | Purpose | Audience |
|----------|---------|----------|
| [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) | Project overview & features | Everyone |
| [README.md](./README.md) | Complete setup & deployment guide | Developers |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | System design & diagrams | Architects |
| [CICD_GUIDE.md](./CICD_GUIDE.md) | CI/CD setup & configuration | DevOps |
| [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) | Command cheat sheet | Everyone |
| [SCRIPTS_GUIDE.md](./SCRIPTS_GUIDE.md) | Script examples & usage | DevOps |

### Component-Specific Guides
| Document | Purpose | Location |
|----------|---------|----------|
| [FRONTEND_GUIDE.md](./frontend/FRONTEND_GUIDE.md) | Angular development | frontend/ |
| [BACKEND_GUIDE.md](./backend/BACKEND_GUIDE.md) | Python Flask development | backend/ |

---

## 🚀 QUICK START PATHS

### Path 1: Local Development
```
1. Read: QUICK_REFERENCE.md
2. Run: setup.sh or setup.bat
3. Run: docker-compose up -d
4. Visit: http://localhost:4200 (Frontend)
5. Visit: http://localhost:5000 (Backend)
```

### Path 2: Deploy to Kubernetes
```
1. Read: README.md (Kubernetes Deployment section)
2. Configure: Update backend/.env
3. Build: Docker images
4. Deploy: kubectl apply -f kubernetes/
5. Verify: kubectl get pods, services
```

### Path 3: Deploy to Azure
```
1. Read: README.md (Azure Infrastructure section)
2. Configure: azure/terraform.tfvars
3. Deploy: terraform apply
4. Access: Azure Portal for resources
```

### Path 4: Setup GitHub Actions
```
1. Read: CICD_GUIDE.md
2. Create: GitHub repository
3. Configure: GitHub Secrets
4. Deploy: Push to main branch
5. Monitor: GitHub Actions tab
```

---

## 🔧 CONFIGURATION CHECKLIST

Before deploying, configure:

### GitHub Secrets
- [ ] `ACR_USERNAME`
- [ ] `ACR_PASSWORD`
- [ ] `AZURE_CREDENTIALS`
- [ ] `AZURE_RESOURCE_GROUP`
- [ ] `AZURE_LOCATION`
- [ ] `AKS_CLUSTER_NAME`
- [ ] `TF_STATE_STORAGE`

### Backend Environment
- [ ] `backend/.env` (copy from `.env.example`)
- [ ] Azure storage account name
- [ ] Key Vault URL
- [ ] Database connection string (if using)

### Terraform Variables
- [ ] `azure/terraform.tfvars`
- [ ] Resource group name
- [ ] Azure region
- [ ] App name prefix

### Kubernetes Secrets
- [ ] Update ConfigMap in `03-configmap-secrets.yaml`
- [ ] Add Azure credentials
- [ ] Update service URLs

---

## 📊 ARCHITECTURE OVERVIEW

```
Browser Request
    ↓
NGINX Ingress (80/443)
    ↓
Kubernetes Service
    ├─ Frontend Pod (Angular)
    ├─ Frontend Pod (Angular)
    ├─ Backend Pod (Python)
    └─ Backend Pod (Python)
    ↓
Azure Services
├─ Storage Account
├─ Key Vault
└─ Application Insights
```

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed diagrams.

---

## 🎯 COMMON TASKS

### Task: Start Local Development
```bash
./setup.sh
docker-compose up -d
```
📖 Guide: [FRONTEND_GUIDE.md](./frontend/FRONTEND_GUIDE.md), [BACKEND_GUIDE.md](./backend/BACKEND_GUIDE.md)

### Task: Build Docker Images
```bash
docker build -t frontend:latest ./frontend
docker build -t backend:latest ./backend
```
📖 Guide: [README.md](./README.md) → Building Docker Images

### Task: Deploy to Kubernetes
```bash
kubectl apply -f kubernetes/
```
📖 Guide: [README.md](./README.md) → Kubernetes Deployment

### Task: Deploy Azure Infrastructure
```bash
cd azure && terraform apply
```
📖 Guide: [README.md](./README.md) → Azure Infrastructure

### Task: View Logs
```bash
# Kubernetes
kubectl logs -f -l app=angular-frontend

# Docker
docker-compose logs -f backend
```
📖 Guide: [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)

### Task: Troubleshoot Issues
```bash
# Check pod status
kubectl describe pod <pod-name>

# Check service connectivity
kubectl exec -it <pod> -- curl http://backend:5000/health
```
📖 Guide: [README.md](./README.md) → Troubleshooting

---

## 🔐 SECURITY CONSIDERATIONS

1. **Secrets Management**
   - Store credentials in GitHub Secrets, not in code
   - Use Azure Key Vault for production secrets
   - Rotate credentials regularly

2. **Network Security**
   - Network policies enforce pod-to-pod communication
   - TLS/SSL encryption for ingress traffic
   - RBAC for Kubernetes access

3. **Container Security**
   - Images scanned in ACR
   - Resource limits enforced
   - Health checks for pod liveness

See [README.md](./README.md) → Security section for more.

---

## 📞 TROUBLESHOOTING QUICK LINKS

| Issue | Solution | Location |
|-------|----------|----------|
| Pod not starting | Check logs | [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) |
| Docker build fails | Verify Dockerfile | [FRONTEND_GUIDE.md](./frontend/FRONTEND_GUIDE.md) |
| Cannot connect to API | Check service/ingress | [README.md](./README.md) |
| Terraform errors | Validate syntax | [README.md](./README.md) |
| GitHub Actions fail | Check secrets | [CICD_GUIDE.md](./CICD_GUIDE.md) |

---

## 📈 MONITORING & LOGS

### Kubernetes Monitoring
```bash
# Pod metrics
kubectl top pods

# View logs
kubectl logs -f <pod-name>

# Describe resources
kubectl describe pod <pod-name>
```

### Azure Monitoring
- Application Insights dashboard
- Log Analytics queries
- Azure Portal resource metrics

See [README.md](./README.md) → Monitoring & Logging

---

## 🔄 WORKFLOW EXAMPLES

### Example 1: Local Testing
```bash
1. ./setup.sh
2. docker-compose up -d
3. Test at http://localhost:4200
4. View logs: docker-compose logs -f
```

### Example 2: Deploy to Kubernetes
```bash
1. Build images
2. Push to ACR
3. kubectl apply -f kubernetes/
4. kubectl rollout status deployment/angular-frontend
```

### Example 3: Deploy to Azure
```bash
1. Configure secrets
2. cd azure && terraform init
3. terraform plan
4. terraform apply
```

### Example 4: CI/CD Full Pipeline
```bash
1. git push origin main
2. GitHub Actions triggers
3. Tests run automatically
4. Docker images build
5. Deployed to Kubernetes
6. Azure resources updated
```

---

## 📚 EXTERNAL RESOURCES

### Documentation
- [Angular Documentation](https://angular.io/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Azure Docs](https://docs.microsoft.com/azure/)
- [Terraform Docs](https://www.terraform.io/docs)
- [GitHub Actions](https://docs.github.com/en/actions)

### Tutorials
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Angular Tutorial](https://angular.io/guide/setup-local)
- [Terraform Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/)

---

## 🎓 LEARNING PATH

### Beginner
1. Start with [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)
2. Read [README.md](./README.md) introduction
3. Run setup scripts
4. Deploy locally with docker-compose

### Intermediate
1. Study component guides (Frontend/Backend)
2. Deploy to Kubernetes
3. Configure CI/CD pipelines
4. Monitor applications

### Advanced
1. Customize Terraform configuration
2. Implement advanced Kubernetes patterns
3. Setup complete GitOps workflow
4. Implement custom monitoring

---

## 💡 TIPS & TRICKS

- Use `QUICK_REFERENCE.md` for command copy-paste
- Keep `.env` files in `.gitignore`
- Use GitHub Secrets for sensitive data
- Monitor logs before/after deployments
- Test locally before pushing to main branch
- Use docker-compose for local development
- Keep Kubernetes manifests in version control

---

## 📞 SUPPORT

If you have questions:
1. Check the relevant guide (see Documentation section)
2. Review Troubleshooting section in [README.md](./README.md)
3. Check [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) for command issues
4. Review error logs and stack traces

---

## ✅ VERIFICATION CHECKLIST

After complete setup:
- [ ] Frontend running at http://localhost:4200
- [ ] Backend API responding at http://localhost:5000/health
- [ ] Docker images building successfully
- [ ] Kubernetes pods deployed and running
- [ ] Ingress routing traffic correctly
- [ ] GitHub Actions workflows enabled
- [ ] All secrets configured
- [ ] Azure resources created
- [ ] Monitoring dashboards accessible

---

**Happy Deploying! 🚀**

For detailed instructions, start with [README.md](./README.md)

*Last Updated: May 2024 | Version: 1.0.0*
