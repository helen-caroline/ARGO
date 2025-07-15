# Outputs do Resource Group
output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Localização do Resource Group"
  value       = azurerm_resource_group.main.location
}

# Outputs do Azure Container Registry
output "acr_name" {
  description = "Nome do Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Servidor de login do ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Username administrativo do ACR"
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Senha administrativa do ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

# Outputs do Azure Kubernetes Service
output "aks_cluster_name" {
  description = "Nome do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_id" {
  description = "ID do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_fqdn" {
  description = "FQDN do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_resource_group" {
  description = "Resource Group dos nós do AKS"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "aks_kubelet_identity" {
  description = "Identidade do kubelet"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Comando para obter credenciais do kubectl
output "kubectl_config_command" {
  description = "Comando para configurar kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

# Outputs de rede
output "vnet_id" {
  description = "ID da Virtual Network"
  value       = azurerm_virtual_network.aks.id
}

output "subnet_id" {
  description = "ID da Subnet"
  value       = azurerm_subnet.aks.id
}

# Output do Log Analytics
output "log_analytics_workspace_id" {
  description = "ID do Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.aks.id
}

# URLs úteis
output "useful_commands" {
  description = "Comandos úteis para gerenciar os recursos"
  value = {
    connect_aks = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.aks.name}"
    acr_login   = "az acr login --name ${azurerm_container_registry.acr.name}"
    view_pods   = "kubectl get pods --all-namespaces"
    view_nodes  = "kubectl get nodes"
  }
}
