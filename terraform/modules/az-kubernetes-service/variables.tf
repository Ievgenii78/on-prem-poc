variable "cluster_name" {
    description = "The name of AKS cluster."
    type = string
}

variable "location" {
    description = "The region of Key Vault."
    type = string
}

variable "resource_group_name" {
    description = "Azure Resource Group where the Managed Kubernetes Cluster should exist."
    type = string
}

# variable "k8s_cluster_private_dns_prefix" {
#     description = "DNS prefix specified when creating the managed cluster."
#     type = string
#     default = ""
# }

variable "dns_prefix" {
    description = "DNS prefix specified when creating the managed cluster."
    type = string
    default = ""
}

variable "kubernetes_version" {
    description = "Version of k8s."
    type = string
}

# variable "node_resource_group" {
#     description = "he name of the Resource Group where the Kubernetes Nodes should exist."
#     type = string
# }

variable "private_cluster_enabled" {
    description = "Should this AKS have its API server only exposed on internal IP addresses?"
    type = bool
}

variable "cluster_default_node_pool" {
    description = "AKS default node pool configuration data."
    type = map
}

variable "cluster_network_profile" {
    description = "AKS network_profile configuration data."
}

variable "cluster_identity" {
    description = "AKS network_profile configuration data."
}

# variable "azurerm_user_assigned_identity_id" {
#     description = "The ID of a user assigned identity."
#     type = string
# }

# variable "azurerm_kubelet_user_assigned_identity_client_id" {
#     description = "The Client ID of the user-defined Managed Identity to be assigned to the Kubelets."
#     type = string
# }

# variable "azurerm_kubelet_user_assigned_identity_object_id" {
#     description = "The Object ID of the user-defined Managed Identity assigned to the Kubelets."
#     type = string
# }

# variable "azurerm_kubelet_user_assigned_identity_id" {
#     description = "The ID of the User Assigned Identity assigned to the Kubelets."
#     type = string
# }

variable "default_node_pool_vnet_subnet_id" {
    description = "The Azure network subnet id for default node pool."
    type = string
}

variable "k8s_cluster_admin_username" {
    description = "The Admin Username for the Cluster."
    type = string
}

variable "common_tags" {
  type        = map(string)
  description = "Default set of tags."
  default     = null
}

variable "azurerm_key_vault_id" {
    type = string
    description = "Azure Key Vault ID to store sensitive and configuration data."
}

variable "cluster_windows_node_pool" {
    description = "Are there Windows node pool in AKS?"
    type = bool
}