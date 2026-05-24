variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

# Node Pool Configuration
variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default"
}

variable "node_vm_size" {
  description = "VM size for the nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 30
}

variable "initial_node_count" {
  description = "Initial number of nodes"
  type        = number
  default     = 2
}

variable "min_node_count" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes"
  type        = number
  default     = 10
}

variable "node_labels" {
  description = "Labels to apply to nodes"
  type        = map(string)
  default = {
    environment = "prod"
  }
}

variable "node_taints" {
  description = "Taints to apply to nodes"
  type        = list(map(string))
  default     = []
}

variable "availability_zones" {
  description = "Availability zones for nodes"
  type        = list(string)
  default     = []
}

# Service Principal
variable "service_principal_client_id" {
  description = "Client ID of the service principal"
  type        = string
}

variable "service_principal_client_secret" {
  description = "Client secret of the service principal"
  type        = string
  sensitive   = true
}

# Monitoring
variable "enable_monitoring" {
  description = "Enable monitoring with Log Analytics"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  type        = string
}

# Network
variable "vnet_subnet_id" {
  description = "ID of the subnet for the cluster"
  type        = string
}

variable "network_plugin" {
  description = "Network plugin (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy (azure or calico)"
  type        = string
  default     = "azure"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU (basic or standard)"
  type        = string
  default     = "standard"
}

variable "api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for API server"
  type        = list(string)
  default     = []
}

# Workload Node Pool
variable "create_workload_node_pool" {
  description = "Create a separate workload node pool"
  type        = bool
  default     = true
}

variable "workload_node_pool_name" {
  description = "Name of the workload node pool"
  type        = string
  default     = "workload"
}

variable "workload_node_vm_size" {
  description = "VM size for workload nodes"
  type        = string
  default     = "Standard_DS3_v2"
}

variable "workload_node_count" {
  description = "Initial workload node count"
  type        = number
  default     = 2
}

variable "workload_min_node_count" {
  description = "Minimum workload node count"
  type        = number
  default     = 1
}

variable "workload_max_node_count" {
  description = "Maximum workload node count"
  type        = number
  default     = 10
}

variable "workload_node_labels" {
  description = "Labels for workload nodes"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
