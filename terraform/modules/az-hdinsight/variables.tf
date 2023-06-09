variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "storage_account_name" {
  description = "The name of the storage account"
  default     = null
}

variable "storage_container_name" {
  description = "The name of the storage container"
  default     = null
}

variable "storage_account" {
  type = object({
    account_kind              = string
    account_tier              = string
    account_replication_type  = string
    enable_https_traffic_only = bool
    min_tls_version           = string
    container_access_type     = string
  })
  description = "Manages an Azure Storage Account"
  default = {
    account_kind              = "StorageV2"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    enable_https_traffic_only = true
    min_tls_version           = "TLS1_2"
    container_access_type     = "private"
  }
}

variable "hdinsight_cluster_type" {
  description = "The type of hdinsight cluster. Valid values are `hadoop`, `hbase`, `interactive-query`, `kafka`, `spark`."
  default     = null
}

variable "log_analytics_workspace_name" {
  description = "The name of log analytics workspace name"
  default     = null
}

variable "kafka_cluster" {
  type = object({
    name                          = string
    cluster_version               = string
    tier                          = string
    tls_min_version               = optional(string)
    encryption_in_transit_enabled = optional(bool)
    kafka_version                 = string
    gateway_username              = string
    gateway_password              = string
  })
  description = "Manages a HDInsight Kafka Cluster"
  default     = null
}

variable "kafka_roles" {
  type = object({
    vm_username  = string
    vm_password  = optional(string)
    ssh_key_file = optional(list(string))
    head_node = object({
      vm_size            = string
      subnet_id          = optional(string)
      virtual_network_id = optional(string)
    })
    worker_node = object({
      vm_size                  = string
      subnet_id                = optional(string)
      target_instance_count    = optional(number)
      virtual_network_id       = optional(string)
      number_of_disks_per_node = number
      script_name              = optional(string)
      script_uri               = optional(string)
      script_parameters        = optional(string)
    })
    zookeeper_node = object({
      vm_size            = string
      subnet_id          = optional(string)
      virtual_network_id = optional(string)
    })
    kafka_management_node = optional(object({
      vm_size            = string
      subnet_id          = optional(string)
      virtual_network_id = optional(string)
    }))
  })
  description = "Manage roles for HDInsight Kafka Cluster"
  default     = null
}

variable "kafka_storage_account_gen2" {
  type = object({
    storage_resource_id          = string
    filesystem_id                = string
    managed_identity_resource_id = string
  })
  default = null
}

variable "kafka_metastores" {
  type = object({
    hive = object({
      server        = string
      database_name = string
      username      = string
      password      = string
    })
    oozie = object({
      server        = string
      database_name = string
      username      = string
      password      = string
    })
    ambari = object({
      server        = string
      database_name = string
      username      = string
      password      = string
    })
  })
  description = "HDInsight metadata with external data stores, available for Apache Hive metastore, Apache Oozie metastore, and Apache Ambari database."
  default     = null
}

variable "enable_kafka_monitoring" {
  description = "Use Azure Monitor logs to monitor HDInsight Kafka cluster"
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}