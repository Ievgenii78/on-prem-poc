#General variables related to the project
variable "resource_owner" {
  description = "Resource Owner for tags"
}

variable "subscriptionId" {
  description = "Resource Owner for tags"
}

variable "financial_identifier" {
  description = "Financial Identifier"
}

variable "project_name" {
  description = "Short name of the project that will be used in resource naming and tagging"
}

variable "location" {
  description = "Azure location"
}

variable "resource_group_name" {
  description = "Name of the resource group used"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

#Subnet variables
variable "virtual_network_name" {
  description = "Virtual Network that used for infrastructure"
  type        = string
}

# k8s cluster
variable "kubernetes_version" {
    description = "Version of k8s."
    type = string
}

variable "cluster_identity" {
    description = "AKS network_profile configuration data."
}

variable "private_cluster_enabled" {
    description = "Should this AKS have its API server only exposed on internal IP addresses?"
    type = bool
}

variable "dns_prefix" {
    description = "DNS prefix specified when creating the managed cluster."
    type = string
}

variable "cluster_default_node_pool" {
    description = "AKS default node pool configuration data."
    type = map
}

# variable "node_resource_group" {
#   description = "Resource group for the k8s nodes"
#   type        = string
# }

variable "cluster_network_profile" {
    description = "AKS network_profile configuration data."
}

variable "cluster_windows_node_pool" {
    description = "Are there Windows node pool in AKS?"
    type = bool
}
