output "cluster_id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "The ID of the AKS cluster"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.main.name
  description = "The name of the AKS cluster"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
  description = "Raw kube config"
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.main.kube_config
  sensitive   = true
  description = "Kube config"
}

output "fqdn" {
  value       = azurerm_kubernetes_cluster.main.fqdn
  description = "FQDN of the AKS cluster"
}

output "api_server_address" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  description = "API server address"
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
  description = "Client certificate for API server"
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
  description = "Client key for API server"
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
  description = "Cluster CA certificate"
}

output "kubelet_identity" {
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0]
  description = "Kubelet identity"
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.main.node_resource_group
  description = "Node resource group name"
}
