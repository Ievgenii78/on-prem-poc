#------------------------------------------------------------
# Local configuration - Default (required). 
#------------------------------------------------------------

locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags, )
}

data "azurerm_log_analytics_workspace" "logws" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = local.resource_group_name
}

#------------------------------------------------------------------
# Storage Account for hdinsight hadoop cluster - Default is "true"
#------------------------------------------------------------------

resource "random_string" "str" {
  count   = var.storage_account_name == null ? 1 : 0
  length  = 6
  special = false
  upper   = false
  keepers = {
    name = local.resource_group_name
  }
}

resource "azurerm_storage_account" "storeacc" {
  name                      = var.storage_account_name == null ? "hdinsightstorage${random_string.str.0.result}" : substr(var.storage_account_name, 0, 24)
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = var.storage_account.account_kind
  account_tier              = var.storage_account.account_tier
  account_replication_type  = var.storage_account.account_replication_type
  enable_https_traffic_only = var.storage_account.enable_https_traffic_only
  min_tls_version           = var.storage_account.min_tls_version
  tags                      = merge({ "Name" = var.storage_account_name == null ? "hdinsightstorage${random_string.str.0.result}" : substr(var.storage_account_name, 0, 24) }, var.tags, )
}

resource "azurerm_storage_container" "storcont" {
  name                  = var.storage_container_name == null ? "hdinsightstore" : var.storage_container_name
  storage_account_name  = azurerm_storage_account.storeacc.name
  container_access_type = var.storage_account.container_access_type
}

#---------------------------------------------------------------
# hdinsight Kafka cluster - Default is "false"
#----------------------------------------------------------------
resource "azurerm_hdinsight_kafka_cluster" "main" {
  count                         = var.hdinsight_cluster_type == "kafka" ? 1 : 0
  name                          = format("%s", var.kafka_cluster.name)
  resource_group_name           = local.resource_group_name
  location                      = local.location
  cluster_version               = var.kafka_cluster.cluster_version
  tier                          = var.kafka_cluster.tier
  tls_min_version               = var.kafka_cluster.tls_min_version
  encryption_in_transit_enabled = var.kafka_cluster.encryption_in_transit_enabled
  tags                          = merge({ "Name" = format("%s", var.kafka_cluster.name) }, var.tags, )

  component_version {
    kafka = var.kafka_cluster.kafka_version
  }

  gateway {
    username = var.kafka_cluster.gateway_username
    password = var.kafka_cluster.gateway_password
  }

  dynamic "roles" {
    for_each = var.kafka_roles != null ? [var.kafka_roles] : []
    content {
      dynamic "head_node" {
        for_each = var.kafka_roles.head_node != null ? [var.kafka_roles.head_node] : []
        content {
          username           = var.kafka_roles.vm_username
          password           = var.kafka_roles.vm_password
          vm_size            = var.kafka_roles.head_node.vm_size
          ssh_keys           = var.kafka_roles.ssh_key_file
          subnet_id          = var.kafka_roles.head_node.subnet_id
          virtual_network_id = var.kafka_roles.head_node.virtual_network_id
        }
      }

      dynamic "worker_node" {
        for_each = var.kafka_roles.worker_node != null ? [var.kafka_roles.worker_node] : []
        content {
          # Either a password or one or more ssh_keys must be specified - but not both.
          username                 = var.kafka_roles.vm_username
          password                 = var.kafka_roles.vm_password
          vm_size                  = var.kafka_roles.worker_node.vm_size
          ssh_keys                 = var.kafka_roles.ssh_key_file
          subnet_id                = var.kafka_roles.worker_node.subnet_id
          target_instance_count    = var.kafka_roles.worker_node.target_instance_count
          virtual_network_id       = var.kafka_roles.worker_node.virtual_network_id
          number_of_disks_per_node = var.kafka_roles.worker_node.number_of_disks_per_node
          script_actions {
            name       = var.kafka_roles.worker_node.script_name
            uri        = var.kafka_roles.worker_node.script_uri
            parameters = var.kafka_roles.worker_node.script_parameters
          }
        }
      }
      dynamic "zookeeper_node" {
        for_each = var.kafka_roles.zookeeper_node != null ? [var.kafka_roles.zookeeper_node] : []
        content {
          username           = var.kafka_roles.vm_username
          password           = var.kafka_roles.vm_password
          vm_size            = var.kafka_roles.zookeeper_node.vm_size
          ssh_keys           = var.kafka_roles.ssh_key_file
          subnet_id          = var.kafka_roles.zookeeper_node.subnet_id
          virtual_network_id = var.kafka_roles.zookeeper_node.virtual_network_id
        }
      }

      # dynamic "kafka_management_node" {
      #   for_each = var.kafka_roles.kafka_management_node != null ? [var.kafka_roles.kafka_management_node] : []
      #   content {
      #     username           = var.kafka_roles.vm_username
      #     password           = var.kafka_roles.vm_password
      #     vm_size            = var.kafka_roles.kafka_management_node.vm_size
      #     ssh_keys           = var.kafka_roles.ssh_key_file
      #     subnet_id          = var.kafka_roles.kafka_management_node.subnet_id
      #     virtual_network_id = var.kafka_roles.kafka_management_node.virtual_network_id
      #   }
      # }
    }
  }

  dynamic "storage_account" {
    for_each = var.kafka_storage_account_gen2 == null ? [1] : []
    content {
      is_default           = true
      storage_account_key  = azurerm_storage_account.storeacc.primary_access_key
      storage_container_id = azurerm_storage_container.storcont.id
    }
  }

  dynamic "storage_account_gen2" {
    for_each = var.kafka_storage_account_gen2 != null ? [var.kafka_storage_account_gen2] : []
    content {
      is_default                   = true
      storage_resource_id          = var.kafka_storage_account_gen2.storage_resource_id
      filesystem_id                = var.kafka_storage_account_gen2.filesystem_id
      managed_identity_resource_id = var.kafka_storage_account_gen2.managed_identity_resource_id
    }
  }

  dynamic "metastores" {
    for_each = var.kafka_metastores != null ? [var.kafka_metastores] : []
    content {
      dynamic "hive" {
        for_each = var.kafka_metastores.hive != null ? [var.kafka_metastores.hive] : []
        content {
          server        = var.kafka_metastores.hive.server
          database_name = var.kafka_metastores.hive.database_name
          username      = var.kafka_metastores.hive.username
          password      = var.kafka_metastores.hive.password
        }
      }

      dynamic "oozie" {
        for_each = var.kafka_metastores.oozie != null ? [var.kafka_metastores.oozie] : []
        content {
          server        = var.kafka_metastores.oozie.server
          database_name = var.kafka_metastores.oozie.database_name
          username      = var.kafka_metastores.oozie.username
          password      = var.kafka_metastores.oozie.password
        }
      }

      dynamic "ambari" {
        for_each = var.kafka_metastores.ambari != null ? [var.kafka_metastores.ambari] : []
        content {
          server        = var.kafka_metastores.ambari.server
          database_name = var.kafka_metastores.ambari.database_name
          username      = var.kafka_metastores.ambari.username
          password      = var.kafka_metastores.ambari.password
        }
      }
    }
  }

  dynamic "monitor" {
    for_each = var.enable_kafka_monitoring ? [1] : []
    content {
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logws.0.workspace_id
      primary_key                = data.azurerm_log_analytics_workspace.logws.0.primary_shared_key
    }
  }

}


