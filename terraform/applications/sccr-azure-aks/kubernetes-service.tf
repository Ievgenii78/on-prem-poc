locals {
  cluster_name = "AKS-${local.location_code}-${local.project_name}-${var.environment}"
  # aks_node_subnet_name = upper("AKS-NODES-${local.location_code}-${local.project_name}-${var.environment}")
  aks_node_subnet_name = upper("BACK-AKS-${local.location_code}-${local.project_name}-${var.environment}")
  aks_node_subnet_id   = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", var.subscriptionId, var.resource_group_name, var.virtual_network_name, local.aks_node_subnet_name)
  k8s_cluster_admin_username = "azureuser"
}

module "azure_kubernetes_cluster" {
  source                         = "./../../modules/az-kubernetes-service"
  providers = {
    azurerm = azurerm
  }
  
  cluster_name             = local.cluster_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  # node_resource_group      = var.node_resource_group
  kubernetes_version       = var.kubernetes_version
  cluster_identity         = var.cluster_identity
  private_cluster_enabled  = var.private_cluster_enabled
  # k8s_cluster_private_dns_prefix = "${var.infrastructure_name}-aks_cluster-${var.index}" # only for private
  dns_prefix               = var.dns_prefix

  cluster_default_node_pool        = var.cluster_default_node_pool
  default_node_pool_vnet_subnet_id = local.aks_node_subnet_id
  cluster_network_profile          = var.cluster_network_profile
  cluster_windows_node_pool        = var.cluster_windows_node_pool
  
  k8s_cluster_admin_username = local.k8s_cluster_admin_username
  azurerm_key_vault_id = local.key_vault_id
}
