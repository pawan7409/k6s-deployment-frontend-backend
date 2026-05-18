# Architecture Diagram & Deployment Flow

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        KUBERNETES CLUSTER (AKS)                         │
│                                                                         │
│  ┌──────────────────────────┐         ┌──────────────────────────┐    │
│  │  FRONTEND POD (Angular)  │         │  BACKEND POD (Python)    │    │
│  │  ├─ Port: 4200          │         │  ├─ Port: 5000          │    │
│  │  ├─ Replicas: 2         │◄────────┤  ├─ Replicas: 2         │    │
│  │  └─ CPU: 500m           │         │  └─ CPU: 500m           │    │
│  │    MEM: 256Mi           │         │    MEM: 512Mi           │    │
│  └──────────────────────────┘         └──────────────────────────┘    │
│           ▲                                      ▲                     │
│           │                                      │                     │
│           │  Service: angular-frontend          │  Service: python-   │
│           │  ClusterIP: 80                      │  backend ClusterIP  │
│           │                                      │  5000               │
│           │                                      │                     │
│           └──────────────────┬───────────────────┘                     │
│                              │                                         │
│                    ┌─────────▼────────┐                               │
│                    │ INGRESS          │                               │
│                    │ ├─ NGINX         │                               │
│                    │ ├─ TLS/SSL       │                               │
│                    │ └─ Rate Limit    │                               │
│                    └─────────┬────────┘                               │
│                              │                                         │
│                    ┌─────────▼────────┐                               │
│                    │ ConfigMaps       │                               │
│                    │ └─ Backend Config│                               │
│                    └──────────────────┘                               │
│                                                                         │
│                    ┌──────────────────┐                               │
│                    │ Network Policies │                               │
│                    │ └─ Security      │                               │
│                    └──────────────────┘                               │
│                                                                         │
│                    ┌──────────────────┐                               │
│                    │ HPA (Autoscaler) │                               │
│                    │ ├─ CPU Based     │                               │
│                    │ └─ Memory Based  │                               │
│                    └──────────────────┘                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
                              │
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
         ▼                    ▼                    ▼
    ┌─────────┐          ┌─────────┐        ┌──────────┐
    │  AZURE  │          │ AZURE   │        │  AZURE   │
    │   APP   │          │ FUNCTION│        │ STORAGE  │
    │ SERVICE │          │   APP   │        │ ACCOUNT  │
    │         │          │         │        │          │
    │Backend  │          │Process  │        │  Blobs   │
    │Frontend │          │Tasks    │        │  Files   │
    └────┬────┘          └────┬────┘        └────┬─────┘
         │                    │                   │
         └────────────────────┼───────────────────┘
                              │
                    ┌─────────▼────────┐
                    │ AZURE KEY VAULT  │
                    │ └─ Secrets       │
                    │ └─ Credentials   │
                    └──────────────────┘
```

## CI/CD Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    GITHUB REPOSITORY                            │
│                                                                 │
│  Developer commits code to main/develop branch                 │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                    ┌─────────▼────────┐
                    │  GITHUB ACTIONS  │
                    │  Triggers All    │
                    │  Workflows       │
                    └─────────┬────────┘
                              │
        ┌─────────────────────┼─────────────────────┬──────────────┐
        │                     │                     │              │
        ▼                     ▼                     ▼              ▼
    ┌────────┐          ┌────────┐          ┌────────┐      ┌──────────┐
    │ TESTS  │          │ DOCKER │          │AZURE   │      │TERRAFORM│
    │WORKFLOW│          │ BUILD  │          │ DEPLOY │      │ DEPLOY  │
    │        │          │WORKFLOW│          │WORKFLOW│      │WORKFLOW │
    ├────────┤          ├────────┤          ├────────┤      ├──────────┤
    │ Lint   │          │Build   │          │Deploy  │      │Deploy    │
    │Tests   │          │Frontend│          │App Svc │      │Infrastructure
    │Build   │          │Push ACR│          │Deploy  │      │          │
    │        │          │Build   │          │Func App│      │          │
    │        │          │Backend │          │        │      │          │
    │        │          │Push ACR│          │        │      │          │
    └────┬───┘          └────┬───┘          └────┬───┘      └────┬─────┘
         │                   │                   │               │
         │ ✅ Pass           │ ✅ Success        │ ✅ Deployed   │ ✅ Success
         │                   │                   │               │
         └───────────────────┴───────────────────┼───────────────┘
                                                │
                                    ┌───────────▼──────────┐
                                    │   MANUAL APPROVAL    │
                                    │  (Optional for Prod) │
                                    └───────────┬──────────┘
                                                │
                                    ┌───────────▼──────────┐
                                    │ KUBERNETES DEPLOY    │
                                    │ Apply Manifests      │
                                    │ Update Images        │
                                    │ Verify Rollout       │
                                    └─────────────────────┘
```

## Data Flow

```
┌──────────────┐
│   Browser   │
└──────┬───────┘
       │ HTTP Request
       │ (http://app.example.com)
       │
       ▼
┌──────────────────────────┐
│  NGINX Ingress           │
│  - Routes requests       │
│  - SSL/TLS termination   │
│  - Rate limiting         │
└──────┬───────────────────┘
       │
       ├─────────────────────────────┬────────────────────────┐
       │                             │                        │
       ▼ /                           ▼ /api                   ▼ Health
┌──────────────────┐        ┌──────────────────┐     ┌──────────────┐
│ Frontend Service │        │ Backend Service  │     │ Monitoring   │
│  (Angular)       │        │ (Python Flask)   │     │              │
│                  │        │                  │     │ Liveness     │
│ - Serve HTML/JS  │        │ - REST Endpoints │     │ Readiness    │
│ - Client logic   │        │ - Data processing│     │ Checks       │
│ - Call APIs      │        │ - Auth           │     │              │
└──────┬───────────┘        └────────┬─────────┘     └──────────────┘
       │                             │
       └────────────────┬────────────┘
                        │
                        ▼
            ┌──────────────────────┐
            │  Azure Services      │
            │ ┌─ Storage Account   │
            │ ├─ Key Vault         │
            │ ├─ App Insights      │
            │ └─ Log Analytics     │
            └──────────────────────┘
```

## Deployment Sequence

```
1. Git Push
   ↓
2. GitHub Actions Triggered
   ├─ Tests Run
   ├─ Code Lint
   ├─ Build Artifacts
   ↓
3. Docker Build (if tests pass)
   ├─ Build Frontend Image
   ├─ Build Backend Image
   ├─ Push to ACR
   ↓
4. Kubernetes Deployment (if build succeeds)
   ├─ Get AKS Credentials
   ├─ Update Deployment Images
   ├─ Apply Manifests
   ├─ Wait for Rollout
   ├─ Verify Health
   ↓
5. Azure Resources (if config changes)
   ├─ Terraform Init
   ├─ Terraform Plan
   ├─ Terraform Apply
   ├─ Deploy to App Service
   ├─ Deploy to Function App
   ↓
6. Monitoring & Alerts
   ├─ Application Insights
   ├─ Log Analytics
   ├─ Health Checks
   ↓
7. Rollback on Failure (Automatic)
   ├─ Revert Deployment
   ├─ Notify Team
   ├─ Alert Dashboards
```

## Network Flow

```
┌────────────────────────────────────────────────────┐
│            Internet / External Traffic             │
└────────────────────────┬───────────────────────────┘
                         │
                         ▼
            ┌────────────────────────┐
            │   Azure Load Balancer  │
            │   Public IP Address    │
            └────────────┬───────────┘
                         │
                         ▼
            ┌────────────────────────┐
            │  NGINX Ingress         │
            │  Port: 80, 443         │
            └────┬───────────────────┘
                 │
        ┌────────┴─────────┐
        │                  │
        ▼                  ▼
   ┌─────────┐        ┌──────────┐
   │Frontend  │        │ Backend  │
   │Pod (K8s) │        │Pod (K8s) │
   └────┬─────┘        └────┬─────┘
        │                   │
        └─────────┬─────────┘
                  │
    ┌─────────────┴──────────────┐
    │    Network Policy          │
    │    (Default Deny)          │
    └─────────────┬──────────────┘
                  │
                  ▼
    ┌──────────────────────────┐
    │  Azure Services          │
    │  (Storage, KeyVault)     │
    └──────────────────────────┘
```

## Security Layers

```
Layer 1: Network Level
└─ Network Policies (K8s)
└─ HTTPS/TLS Encryption

Layer 2: Container Level
└─ Pod Security Policies
└─ Resource Limits
└─ Health Checks

Layer 3: Application Level
└─ Input Validation
└─ CORS Policy
└─ Error Handling

Layer 4: Azure Level
└─ Key Vault (Secrets)
└─ Managed Identity
└─ RBAC Policies
└─ Audit Logging
```

## Scaling Strategy

```
Horizontal Scaling (HPA)
├─ Frontend: 2-5 replicas
│  ├─ Trigger: CPU > 70%, Memory > 80%
│  └─ Scale-up: +1 pod per minute
└─ Backend: 2-10 replicas
   ├─ Trigger: CPU > 70%, Memory > 80%
   └─ Scale-up: +1 pod per minute

Vertical Scaling (Resource Limits)
├─ Frontend
│  ├─ Request: 128Mi RAM, 100m CPU
│  └─ Limit: 256Mi RAM, 500m CPU
└─ Backend
   ├─ Request: 256Mi RAM, 100m CPU
   └─ Limit: 512Mi RAM, 500m CPU

Node Scaling (AKS)
└─ Cluster Auto-scaler
   ├─ Min nodes: 1
   ├─ Max nodes: 10
   └─ Trigger: Unschedulable pods
```
