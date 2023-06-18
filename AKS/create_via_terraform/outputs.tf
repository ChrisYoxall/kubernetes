output "id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "host" {
  value     = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  sensitive = true
}