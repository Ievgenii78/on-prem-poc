locals {
  kafka_cluster_name           = "KAFKA-CLSTR-${local.location_code}-${local.project_name}-${var.environment}"
  storage_account_name         = lower("storhdi${local.location_code}${local.project_name}${var.environment}")
  storage_container_name       = lower("conthdi${local.location_code}${local.project_name}${var.environment}")
  log_analytics_workspace_name = "LOG-HDI-${local.location_code}-${local.project_name}-${var.environment}"
}

#Creates storage account to store SH scripts for further execution in scope of HDInsight Kafka Cluster
# resource "azurerm_storage_account" "kafka_connect_storage" {
#   name                     = "${local.storage_account_name}sh"
#   resource_group_name      = var.resource_group_name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = local.default_mandatory_tags
# }

# #Creates blob to store SH scripts for further execution in scope of HDInsight Kafka Cluster
# resource "azurerm_storage_container" "kafka_connect_container" {
#   name                  = "${local.storage_container_name}sh"
#   storage_account_name  = azurerm_storage_account.kafka_connect_storage.name
#   container_access_type = "private"
# }

#Uploads Kafka-Connect script for further execution in scope of HDInsight Kafka Cluster
resource "azurerm_storage_blob" "kafka_connect_sh" {
  name                   = "kafka-connect.sh"
  type                   = "Block"
  source                 = "${path.module}/kafka-connect/kafka-connect.sh"
  storage_account_name   = module.hdinsight.storage_account_name
  storage_container_name = module.hdinsight.storage_container_name
}

#Creates password for kafka_gateway
resource "random_password" "kafka_gateway_password" {
  length           = 14
  lower            = true
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "_"
  special          = true
  upper            = true
}

#Password for Kafka Cluster Gateway
resource "azurerm_key_vault_secret" "kafka_gateway_password" {
  name         = "KafkaGateway-password"
  value        = random_password.kafka_gateway_password.result
  key_vault_id = module.key-vault.id

  depends_on = [random_password.kafka_gateway_password, module.key-vault]
}

#Generate private/public key for Kafka Cluster nodes
resource "tls_private_key" "kafka_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Create Azure SSH resource that contains public SSH of Kafka Cluster
resource "azurerm_ssh_public_key" "kafka_public_key" {
  name                = local.kafka_public_key_name
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = tls_private_key.kafka_private_key.public_key_openssh
}

#Public SSH key for Kafka Cluster Nodes stored in Azure KeyVaut
resource "azurerm_key_vault_secret" "kafka_vm_ssh" {
  name         = "KafkaVM-SSH"
  value        = tls_private_key.kafka_private_key.private_key_pem
  key_vault_id = module.key-vault.id

  depends_on = [tls_private_key.kafka_private_key, module.key-vault]
}

#Log Analytics Workspace for Kafka-Cluster
resource "azurerm_log_analytics_workspace" "hdi_log_analytics" {
  name                       = local.log_analytics_workspace_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = "PerGB2018"
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  retention_in_days          = 30
}

#Azure HDInsight Kafka Cluster creation
module "hdinsight" {
  source = "./../../modules/az-hdinsight"

  # By default, this module will not create a resource group. Location will be same as existing RG.
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  # set the argument to `create_resource_group = true` to create new resrouce group.
  resource_group_name = var.resource_group_name
  location            = var.location

  # The type of hdinsight cluster to create 
  # Valid values are `hadoop`, `hbase`, `interactive_query`, `kafka`, `spark`.
  hdinsight_cluster_type = "kafka"

  # Hdinsight Kafka cluster configuration. Gateway credentials must be different from the one used 
  # for the `head_node`, `worker_node` and `zookeeper_node` roles.
  kafka_cluster = {
    name             = local.kafka_cluster_name
    cluster_version  = "4.0"
    gateway_username = var.gateway_username
    gateway_password = random_password.kafka_gateway_password.result
    kafka_version    = "2.1"
    tier             = var.kafka_cluster_tier
  }

  # Node configuration
  # Either a password or one or more ssh_keys must be specified - but not both.
  # Password must be at least 10 characters in length and must contain digits,uppercase, 
  # lower case letters and non-alphanumeric characters 
  kafka_roles = {
    vm_username  = var.vm_username
    ssh_key_file = [tls_private_key.kafka_private_key.public_key_openssh]
    head_node = {
      vm_size            = var.head_vm_size
      subnet_id          = local.hdi_subnet_id
      virtual_network_id = local.virtual_network_id
    }
    worker_node = {
      vm_size                  = var.worker_vm_size
      subnet_id                = local.hdi_subnet_id
      virtual_network_id       = local.virtual_network_id
      target_instance_count    = 3
      number_of_disks_per_node = 1
      script_name              = "kafka-connect-install"
      script_uri               = "${azurerm_storage_blob.kafka_connect_sh.url}"
      script_parameters        = "${random_password.kafka_gateway_password.result}"
    }
    zookeeper_node = {
      vm_size            = var.zoo_vm_size
      subnet_id          = local.hdi_subnet_id
      virtual_network_id = local.virtual_network_id
    }
  }

  # Use Azure Monitor logs to monitor HDInsight clusters. Recommended to place both the HDInsight 
  # cluster and the Log Analytics workspace in the same region for better performance.
  enable_kafka_monitoring      = true
  log_analytics_workspace_name = azurerm_log_analytics_workspace.hdi_log_analytics.name

  # Tags for Azure Resources
  tags = local.default_mandatory_tags

  depends_on = [
    module.key-vault,
    azurerm_key_vault_secret.kafka_gateway_password,
    azurerm_key_vault_secret.kafka_vm_ssh,
    azurerm_log_analytics_workspace.hdi_log_analytics,
    azurerm_mysql_flexible_server.mysql
  ]
}