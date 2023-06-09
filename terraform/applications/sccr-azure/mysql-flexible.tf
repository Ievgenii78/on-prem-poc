# Naming for resources that will be created
locals {
  sql_flexible_name = lower("SQLF-${local.location_code}-${local.project_name}-${var.environment}")
  sql_database_name = lower("SQDB-${local.location_code}-${local.project_name}-${var.environment}")
  sql_firewall_name = lower("SQFW-${local.location_code}-${local.project_name}-${var.environment}")
}

#Generats password for MySQL Flexible Server that will be stored in KeyVaul
resource "random_password" "mysql_password" {
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

#Password for MySQL Flexible Server
resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "MySQL-server-password"
  value        = random_password.mysql_password.result
  key_vault_id = module.key-vault.id

  depends_on = [random_password.mysql_password, module.key-vault]
}

#Manages the MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql" {
  location               = var.location
  name                   = local.sql_flexible_name
  resource_group_name    = var.resource_group_name
  administrator_login    = "sccrpocmysql"
  administrator_password = random_password.mysql_password.result
  backup_retention_days  = 7
  #delegated_subnet_id          = local.subnet_id
  geo_redundant_backup_enabled = false

  sku_name = "GP_Standard_D2ds_v4"
  version  = "8.0.21"
  zone     = "1"

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }
  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }
  storage {
    iops    = 360
    size_gb = 20
  }

  depends_on = [random_password.mysql_password, module.key-vault]
}

# Manages the MySQL Flexible Server Database
resource "azurerm_mysql_flexible_database" "main" {
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
  name                = local.sql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
}

# Manages the MySQL Flexible Server Database
resource "azurerm_mysql_flexible_server_firewall_rule" "main" {
  name                = local.sql_firewall_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

#Restores MySQL database dump from file
resource "null_resource" "restore_mysql_db" {
  depends_on = [
    azurerm_mysql_flexible_database.main,
    azurerm_mysql_flexible_server.mysql,
    azurerm_mysql_flexible_server_firewall_rule.main
  ]

  provisioner "local-exec" {
    command = "mysql -h ${azurerm_mysql_flexible_server.mysql.fqdn} -u ${azurerm_mysql_flexible_server.mysql.administrator_login} -p${random_password.mysql_password.result} ${azurerm_mysql_flexible_database.main.name} < ${path.module}/inventory_backup.sql"
  }
}
