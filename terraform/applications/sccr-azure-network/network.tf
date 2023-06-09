locals {
  main_subnet_name      = upper("BACK-SQL-${local.location_code}-${local.project_name}-${var.environment}")
  vm_subnet_name        = upper("BACK-VM-${local.location_code}-${local.project_name}-${var.environment}")
  hdinsight_subnet_name = upper("BACK-HDI-${local.location_code}-${local.project_name}-${var.environment}")
  aks_subnet_name       = upper("BACK-AKS-${local.location_code}-${local.project_name}-${var.environment}")
  bastion_subnet_name   = "AzureBastionSubnet"
}

module "azure_network_main_subnet" {
  source = "./../../modules/az-subnet"

  subnet_name          = local.main_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.136.82.0/28"] # .82.1 - .82.14
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.Web"]
  subnet_delegation = {
    db-mysql-flexible = [
      {
        name    = "Microsoft.DBforMySQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    ]
  }
}

module "azure_network_hdinsight_subnet" {
  source = "./../../modules/az-subnet"

  subnet_name          = local.hdinsight_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.136.82.32/27"] # .82.33 - .82.62
  # service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.Web"]
  # subnet_delegation = {
  #   db-mysql-flexible = [
  #     {
  #       name    = "Microsoft.ContainerService/managedClusters"
  #       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/read", "Microsoft.Network/virtualNetworks/subnets/action"]
  #     }
  #   ]
  # }
}

module "azure_network_aks_subnet" {
  source = "./../../modules/az-subnet"

  subnet_name          = local.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.136.82.64/26"] # .82.65 - .82.126
}

module "azure_network_vm_subnet" {
  source = "./../../modules/az-subnet"

  subnet_name          = local.vm_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.136.82.176/28"] # .82.177 - .82.190
}

module "azure_network_bastion_subnet" {
  source = "./../../modules/az-subnet"

  subnet_name          = local.bastion_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.136.82.192/26"] # .82.193 - .82.254
}
