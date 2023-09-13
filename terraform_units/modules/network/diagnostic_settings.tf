resource "azurerm_monitor_diagnostic_setting" "nic" {
  count              = var.is_diagnostic_settings_enabled ? 1 : 0
  name               = "nic-${count.index}-diag"
  target_resource_id = azurerm_network_interface.oracle_db[count.index].id
  storage_account_id = var.storage_account_id

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  count              = var.is_diagnostic_settings_enabled ? 1 : 0
  name               = "nsg"
  target_resource_id = azurerm_network_security_group.blank.id
  storage_account_id = var.storage_account_id

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.nsg[count.index].log_category_types)
    content {
      category = enabled_log.value
      retention_policy {
        enabled = false
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "pip" {
  count              = var.is_diagnostic_settings_enabled ? 1 : 0
  name               = "pip"
  target_resource_id = azurerm_public_ip.vm_pip.id
  storage_account_id = var.storage_account_id

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.pip[count.index].log_category_types)
    content {
      category = enabled_log.value
      retention_policy {
        enabled = false
      }
    }
  }

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "nic" {
  count       = var.is_diagnostic_settings_enabled ? 1 : 0
  resource_id = data.azurerm_network_interface.nic[count.index].id
}

data "azurerm_monitor_diagnostic_categories" "nsg" {
  count       = var.is_diagnostic_settings_enabled ? 1 : 0
  resource_id = data.azurerm_network_security_group.nsg[count.index].id
}

data "azurerm_monitor_diagnostic_categories" "pip" {
  count       = var.is_diagnostic_settings_enabled ? 1 : 0
  resource_id = data.azurerm_public_ip.pip[count.index].id
}

data "azurerm_network_interface" "nic" {
  count               = 1
  name                = "oraclevmnic1"
  resource_group_name = var.resource_group.name
}

data "azurerm_network_security_group" "nsg" {
  count               = 1
  name                = "blank"
  resource_group_name = var.resource_group.name
}

data "azurerm_public_ip" "pip" {
  count               = 1
  name                = "vmpip"
  resource_group_name = var.resource_group.name
}
