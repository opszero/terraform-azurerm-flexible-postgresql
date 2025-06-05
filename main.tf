data "azurerm_client_config" "current" {}

data "azuread_group" "main" {
  count        = var.active_directory_auth_enabled != null && var.principal_name != null ? 1 : 0
  display_name = var.principal_name
}

locals {
  resource_group_name = var.resource_group_name
  location            = var.location
  tier_map = {
    "GeneralPurpose"  = "GP"
    "Burstable"       = "B"
    "MemoryOptimized" = "MO"
  }
}

resource "random_password" "main" {
  count       = var.enabled && var.admin_password == null ? 1 : 0
  length      = var.admin_password_length
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false
}

resource "azurerm_postgresql_flexible_server" "main" {
  count                             = var.enabled ? 1 : 0
  name                              = var.server_custom_name != null ? var.server_custom_name : format("%s-pgsql-flexible-server", var.name)
  resource_group_name               = local.resource_group_name
  location                          = local.location
  administrator_login               = var.admin_username
  administrator_password            = var.admin_password == null ? random_password.main[0].result : var.admin_password
  backup_retention_days             = var.backup_retention_days
  delegated_subnet_id               = var.delegated_subnet_id
  private_dns_zone_id               = var.private_dns ? azurerm_private_dns_zone.main[0].id : var.existing_private_dns_zone_id
  sku_name                          = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), "Standard", var.size])
  create_mode                       = var.create_mode
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  point_in_time_restore_time_in_utc = var.create_mode == "PointInTimeRestore" ? var.point_in_time_restore_time_in_utc : null
  public_network_access_enabled     = var.public_network_access_enabled
  source_server_id                  = var.create_mode == "PointInTimeRestore" ? var.source_server_id : null
  storage_mb                        = var.storage_mb
  version                           = var.postgresql_version
  zone                              = var.zone
  tags                              = var.tags
  dynamic "high_availability" {
    for_each = toset(var.high_availability != null && var.tier != "Burstable" ? [var.high_availability] : [])

    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone", 1)
    }
  }

  dynamic "maintenance_window" {
    for_each = toset(var.maintenance_window != null ? [var.maintenance_window] : [])
    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }

  dynamic "authentication" {
    for_each = var.enabled && var.active_directory_auth_enabled ? [1] : [0]

    content {
      active_directory_auth_enabled = var.active_directory_auth_enabled
      tenant_id                     = data.azurerm_client_config.current.tenant_id
    }
  }

  dynamic "identity" {
    for_each = var.cmk_encryption_enabled ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.identity[0].id]
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.cmk_encryption_enabled ? [1] : []
    content {
      key_vault_key_id                     = azurerm_key_vault_key.kvkey[0].id
      primary_user_assigned_identity_id    = azurerm_user_assigned_identity.identity[0].id
      geo_backup_key_vault_key_id          = var.geo_redundant_backup_enabled ? var.geo_backup_key_vault_key_id : null
      geo_backup_user_assigned_identity_id = var.geo_redundant_backup_enabled ? var.geo_backup_user_assigned_identity_id : null

    }
  }
  depends_on = [azurerm_private_dns_zone_virtual_network_link.main, azurerm_private_dns_zone_virtual_network_link.main2]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      authentication[0].tenant_id
    ]
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  count               = var.enabled && var.cmk_encryption_enabled ? 1 : 0
  location            = local.location
  name                = format("%s-pgsql-mid", var.name)
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "rbac_keyvault_crypto_officer" {
  for_each             = toset(var.enabled && var.cmk_encryption_enabled ? var.admin_objects_ids : [])
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "identity_assigned" {
  depends_on           = [azurerm_user_assigned_identity.identity]
  count                = var.enabled && var.cmk_encryption_enabled ? 1 : 0
  principal_id         = azurerm_user_assigned_identity.identity[0].principal_id
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

resource "azurerm_key_vault_key" "kvkey" {
  depends_on      = [azurerm_role_assignment.identity_assigned, azurerm_role_assignment.rbac_keyvault_crypto_officer]
  count           = var.enabled && var.cmk_encryption_enabled ? 1 : 0
  name            = format("%s-pgsql-kv-key", var.name)
  expiration_date = var.expiration_date
  key_vault_id    = var.key_vault_id
  key_type        = "RSA"
  key_size        = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  dynamic "rotation_policy" {
    for_each = var.rotation_policy != null ? var.rotation_policy : {}
    content {
      automatic {
        time_before_expiry = rotation_policy.value.time_before_expiry
      }

      expire_after         = rotation_policy.value.expire_after
      notify_before_expiry = rotation_policy.value.notify_before_expiry
    }
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rules" {
  for_each = var.enabled && !var.private_dns ? var.allowed_cidrs : {}

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.main[0].id
  start_ip_address = cidrhost(trimspace(each.value), 0)
  end_ip_address   = cidrhost(trimspace(each.value), -1)

}

resource "azurerm_postgresql_flexible_server_database" "main" {
  for_each   = var.enabled ? toset(var.database_names) : []
  name       = each.value
  server_id  = azurerm_postgresql_flexible_server.main[0].id
  charset    = var.charset
  collation  = var.collation
  depends_on = [azurerm_postgresql_flexible_server.main]
}

resource "azurerm_postgresql_flexible_server_configuration" "main" {
  for_each   = var.enabled ? var.server_configurations : {}
  name       = each.key
  server_id  = azurerm_postgresql_flexible_server.main[0].id
  value      = each.value
  depends_on = [azurerm_postgresql_flexible_server.main]
}

resource "azurerm_private_dns_zone" "main" {
  count               = var.enabled && var.private_dns ? 1 : 0
  name                = format("%s.privatelink.postgres.database.azure.com", var.name)
  resource_group_name = local.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  count                 = var.enabled && var.private_dns ? 1 : 0
  name                  = format("%s-pgsql-vnet-link", var.name)
  private_dns_zone_name = azurerm_private_dns_zone.main[0].name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = local.resource_group_name
  registration_enabled  = var.registration_enabled
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main2" {
  count                 = var.enabled && var.existing_private_dns_zone ? 1 : 0
  name                  = format("%s-pgsql-vnet-link", var.name)
  private_dns_zone_name = var.existing_private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.main_rg_name
  registration_enabled  = var.registration_enabled
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "addon_vent_link" {
  count                 = var.enabled && var.addon_vent_link ? 1 : 0
  name                  = format("%s-pgsql-vnet-link-addon", var.name)
  resource_group_name   = var.addon_resource_group_name
  private_dns_zone_name = var.existing_private_dns_zone_name == "" ? azurerm_private_dns_zone.main[0].name : var.existing_private_dns_zone_name
  virtual_network_id    = var.addon_virtual_network_id
  tags                  = var.tags
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "main" {
  count               = var.enabled && var.active_directory_auth_enabled && var.principal_name != null ? 1 : 0
  server_name         = azurerm_postgresql_flexible_server.main[0].name
  resource_group_name = local.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.ad_admin_objects_id == null ? data.azuread_group.main[0].object_id : var.ad_admin_objects_id
  principal_name      = var.principal_name
  principal_type      = var.principal_type
}
