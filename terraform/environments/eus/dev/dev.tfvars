#General###---Project variables block---###
project_name         = "SCCSPOC"
environment          = "DEV"
location             = "East US"
resource_group_name  = "RG-EUS-SCCSPOC-DEV"
resource_owner       = "egoldberg@sphera.com"
virtual_network_name = "VNET-EUS-SCCSPOC-DEV-001"
financial_identifier = "SCCR-AZURE"
subscriptionId       = "3b9aa441-4ced-4007-82a9-b4d4af15d363"

#k8s cluster
# node_resource_group = "RG-EUS-SCCSPOC-DEV-002"
kubernetes_version = "1.26.0"
private_cluster_enabled = false
cluster_windows_node_pool = false
dns_prefix = "aks-eus-sccspoc"
cluster_default_node_pool = {
  name               = "default"
  node_count         = 2
  # vm_size            = "Standard_E8as_v5"
  vm_size            = "Standard_E8S_v3"
  type               = "VirtualMachineScaleSets"
}
cluster_network_profile = {
  # network_plugin     = "azure"
  network_plugin     = "kubenet"
  # network_policy     = "azure"
  network_policy     = "calico"
#   dns_service_ip     = "10.0.8.10"
#   docker_bridge_cidr = "172.17.0.1/16"
#   service_cidr       = "10.0.8.0/24"
#   load_balancer_sku  = "Standard"
}
cluster_identity = {
  type = "SystemAssigned"
}

#HDInsight cluster setup
gateway_username   = "sccrpockafkagw"
vm_username        = "sccrpockafkavm"
head_vm_size       = "Standard_D3_V2"
worker_vm_size     = "Standard_D3_V2"
zoo_vm_size        = "Standard_D3_V2"
kafka_cluster_tier = "Standard"