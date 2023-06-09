locals {

  environment_names = {
    # env name = type of env
    "TEST" = "DEV"
    "DEV"  = "DEV"
    "UAT"  = "UAT"
    "QA"   = "QA"
    "PPE"  = "PPE"
    "PROD" = "PROD"
  }

  environment_full_names = {
    "TEST"    = "DEVELOPMENT"
    "DEV"     = "DEVELOPMENT"
    "QA"      = "QUALITY-ASSURANCE"
    "STAGING" = "STAGING"
    "PPE"     = "PRE-PRODUCTION"
    "PROD"    = "PRODUCTION"
  }
  location_codes = {
    "East US 2"  = "EUS2"
    "East US"    = "EUS"
    "Central US" = "CUS"
  }
  location_names = {
    "East US 2"  = "eastus2"
    "East US"    = "eastus"
    "Central US" = "centralus"
  }

  site = {
    primary   = "East US"
    secondary = "Central US"
  }

  resource_owner             = var.resource_owner
  project_name               = var.project_name
  project_name_full          = "Sphera Cloud Corporate Reporting in Azure"
  environment_type           = local.environment_names[var.environment]
  environment_type_full_name = local.environment_full_names[local.environment_type]
  location_name              = local.location_names[var.location]
  location_code              = local.location_codes[var.location]
  default_mandatory_tags = {
    "environment-type" = local.environment_type
    #"application-asset-insight-id"    = local.asset_id
    "resource-owner" = local.resource_owner
    "project-name"   = local.project_name
  }

  #Network locals
  sql_subnet_name = "BACK-SQL-${local.location_code}-${local.project_name}-${var.environment}"
  sql_subnet_id   = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", var.subscriptionId, var.resource_group_name, var.virtual_network_name, local.sql_subnet_name)
  #example output #/subscriptions/3b9aa441-4ced-4007-82a9-b4d4af15d363/resourceGroups/RG-EUS-SCCSPOC-DEV/providers/Microsoft.Network/virtualNetworks/VNET-EUS-SCCSPOC-DEV-001

  hdi_subnet_name = "BACK-HDI-${local.location_code}-${local.project_name}-${var.environment}"
  hdi_subnet_id   = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", var.subscriptionId, var.resource_group_name, var.virtual_network_name, local.hdi_subnet_name)

  virtual_network_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s", var.subscriptionId, var.resource_group_name, var.virtual_network_name)

}