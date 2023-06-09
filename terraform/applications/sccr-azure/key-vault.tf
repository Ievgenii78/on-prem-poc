locals {
  kv_name               = "KV-${local.location_code}-${local.project_name}-${var.environment}"
  kafka_public_key_name = "SSH-KAFKA-${local.location_code}-${local.project_name}-${var.environment}"
}

###########################################
#KeyVault to store infrastructure secrets
###########################################
# resource "random_id" "vault_id" {
#   byte_length = 2
# }

module "key-vault" {
  source = "./../../modules/az-keyvault"
  #name                            = "${local.kv_name}-${random_id.vault_id.hex}"
  name                            = local.kv_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tags                            = local.default_mandatory_tags
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false

  access_policies = [
    {
      object_id               = data.azurerm_client_config.main.object_id
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      storage_permissions     = []
    }
  ]

  # network_acls = {
  #   bypass                     = "AzureServices"
  #   default_action             = "Deny"
  #   virtual_network_subnet_ids = [local.subnet_id]
  #   ip_rules                   = []
  # }

}