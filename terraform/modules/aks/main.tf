# Azure Kubernetes Service (AKS) Module
# Purpose: Managed Kubernetes cluster for frontend and backend services

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  # Default Node Pool
  default_node_pool {
    name            = var.default_node_pool_name
    node_count      = var.initial_node_count
    vm_size         = var.node_vm_size
    os_disk_size_gb = var.os_disk_size_gb
    
    # Network configuration
    vnet_subnet_id = var.vnet_subnet_id

    # Scaling
    min_count       = var.min_node_count
    max_count       = var.max_node_count
    enable_auto_scaling = true

    # Labels
    node_labels = var.node_labels

    # Availability zones
    zones = var.availability_zones

    # OS SKU
    os_sku = "Ubuntu"

    tags = merge(
      var.tags,
      {
        Name = "${var.cluster_name}-default-pool"
      }
    )
  }

  # Service Principal
  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  # Monitoring with OMS Agent
  oms_agent_identity {
    client_id                      = null
    object_id                      = null
    user_assigned_identity_id      = null
  }

  monitor_metrics {
    enabled                    = var.enable_monitoring
    workspace_id               = var.log_analytics_workspace_id
  }

  # Network
  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    load_balancer_sku = var.load_balancer_sku
  }

  # API Server Access Profile (security)
  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  # RBAC
  role_based_access_control_enabled = true

  # Tags
  tags = merge(
    var.tags,
    {
      Name        = var.cluster_name
      Environment = var.environment
    }
  )

  depends_on = [
    var.log_analytics_workspace_id,
    var.vnet_subnet_id
  ]
}

# Node Pool for workloads
resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  count                 = var.create_workload_node_pool ? 1 : 0
  name                  = var.workload_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.workload_node_vm_size
  node_count            = var.workload_node_count
  os_disk_size_gb       = var.os_disk_size_gb
  
  vnet_subnet_id = var.vnet_subnet_id
  
  min_count = var.workload_min_node_count
  max_count = var.workload_max_node_count
  enable_auto_scaling = true

  node_labels = merge(
    var.workload_node_labels,
    {
      workload = "applications"
    }
  )

  zones = var.availability_zones

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-workload-pool"
    }
  )
}
