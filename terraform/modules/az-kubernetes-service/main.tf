
# data "azurerm_client_config" "current" {}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "random_password" "vm_instance_password" {
  count            = var.cluster_windows_node_pool ? 1 : 0
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "@$#!"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                       = var.cluster_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  # node_resource_group        = var.node_resource_group
  kubernetes_version         = var.kubernetes_version
  private_cluster_enabled    = var.private_cluster_enabled
  # private_dns_zone_id        = var.azurerm_private_dns_zone_id
  # dns_prefix_private_cluster = var.k8s_cluster_private_dns_prefix
  dns_prefix                 = var.dns_prefix

  tags = var.common_tags

  default_node_pool {
    name               = lookup(var.cluster_default_node_pool, "name")
    node_count         = lookup(var.cluster_default_node_pool, "node_count")
    vm_size            = lookup(var.cluster_default_node_pool, "vm_size")
    type               = lookup(var.cluster_default_node_pool, "type")
    vnet_subnet_id     = var.default_node_pool_vnet_subnet_id
  }

  identity {
    type = lookup(var.cluster_identity, "type")
  }

  # kubelet_identity {
  #   client_id                 = var.azurerm_kubelet_user_assigned_identity_client_id
  #   object_id                 = var.azurerm_kubelet_user_assigned_identity_object_id
  #   user_assigned_identity_id = var.azurerm_kubelet_user_assigned_identity_id
  # }

  network_profile {
    network_plugin     = lookup(var.cluster_network_profile, "network_plugin")
    # network_mode       = lookup(var.azurerm_kubernetes_cluster_network_profile, "network_mode")
    network_policy     = lookup(var.cluster_network_profile, "network_policy")
    # dns_service_ip     = lookup(var.k8s_cluster_network_profile, "dns_service_ip")
    # docker_bridge_cidr = lookup(var.k8s_cluster_network_profile, "docker_bridge_cidr")
    # service_cidr       = lookup(var.k8s_cluster_network_profile, "service_cidr")
    # load_balancer_sku  = lookup(var.cluster_network_profile, "load_balancer_sku")
  }
  
  linux_profile {
    admin_username = var.k8s_cluster_admin_username
    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  dynamic "windows_profile" {
    for_each = var.cluster_windows_node_pool ? [{}] : []
    content {
      admin_username = var.azurerm_kubernetes_cluster_admin_username
      admin_password = random_password.vm_instance_password[0].result
    }
  }
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = "${var.cluster_name}-admin-username"
  value        = var.k8s_cluster_admin_username
  key_vault_id = var.azurerm_key_vault_id
}

resource "azurerm_key_vault_secret" "windows_profile_password" {
  count        = var.cluster_windows_node_pool ? 1 : 0
  name         = "${var.cluster_name}-windows-profile-password"
  value        = random_password.vm_instance_password[0].result
  key_vault_id = var.azurerm_key_vault_id
  content_type = "Sensitive"
}

resource "azurerm_key_vault_secret" "private_key_pem" {
  name         = "${var.cluster_name}-private-key"
  value        = tls_private_key.ssh.private_key_pem
  key_vault_id = var.azurerm_key_vault_id
  content_type = "Sensitive"
}

resource "azurerm_key_vault_secret" "public_key_pem" {
  name         = "${var.cluster_name}-public-key"
  value        = tls_private_key.ssh.public_key_pem
  key_vault_id = var.azurerm_key_vault_id
  content_type = "Sensitive"
}