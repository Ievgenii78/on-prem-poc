output "kafka_cluster_id" {
  description = "The ID of the HDInsight Kafka Cluster"
  value       = var.hdinsight_cluster_type == "kafka" ? azurerm_hdinsight_kafka_cluster.main.0.id : null
}

output "kafka_cluster_https_endpoint" {
  description = "The HTTPS Connectivity Endpoint for this HDInsight Kafka Cluster"
  value       = var.hdinsight_cluster_type == "kafka" ? azurerm_hdinsight_kafka_cluster.main.0.https_endpoint : null
}

output "kafka_cluster_ssh_endpoint" {
  description = "The SSH Connectivity Endpoint for this HDInsight Kafka Cluster"
  value       = var.hdinsight_cluster_type == "kafka" ? azurerm_hdinsight_kafka_cluster.main.0.ssh_endpoint : null
}

output "storage_account_name" {
  description = "The name of the resource group in which to create the virtual network."
  value       = azurerm_storage_account.storeacc.name
}

output "storage_container_name" {
  description = "The name of the resource group in which to create the virtual network."
  value       = azurerm_storage_container.storcont.name
}