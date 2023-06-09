
#General Outputs

output "financial_identifier" {
  value = var.financial_identifier
}

output "resource_owner" {
  value = local.resource_owner
}

output "project_name" {
  value = local.project_name
}

output "location_name" {
  value = local.location_name
}
output "project_name_full" {
  value = local.project_name_full
}
output "tenant_id" {
  value = data.azurerm_client_config.main.tenant_id
}

output "client_id" {
  value = data.azurerm_client_config.main.client_id
}

output "service_principal_object_id" {
  value = data.azurerm_client_config.main.object_id
}

output "environment_type" {
  value       = local.environment_type
  description = "Application environment tag, eg. PRODUCTION, PRE-PRODUCTION, QUALITY-ASSURANCE, INTEGRATION TESTING, DEVELOPMENT, LAB"

}

output "location" {
  value = var.location
}

#Tags
output "mandatory_tags" {
  value = local.default_mandatory_tags
}

# Kafka cluster outputs
output "kafka_cluster_id" {
  description = "The ID of the HDInsight Kafka Cluster"
  value       = module.hdinsight.kafka_cluster_id
}

output "kafka_cluster_https_endpoint" {
  description = "The HTTPS Connectivity Endpoint for this HDInsight Kafka Cluster"
  value       = module.hdinsight.kafka_cluster_https_endpoint
}

output "kafka_cluster_ssh_endpoint" {
  description = "The SSH Connectivity Endpoint for this HDInsight Kafka Cluster"
  value       = module.hdinsight.kafka_cluster_ssh_endpoint
}

output "kafka_cluster_storeacc_name" {
  description = "The ID of the HDInsight Kafka Cluster"
  value       = module.hdinsight.storage_account_name
}

output "kafka_cluster_storecont_name" {
  description = "The ID of the HDInsight Kafka Cluster"
  value       = module.hdinsight.storage_container_name
}