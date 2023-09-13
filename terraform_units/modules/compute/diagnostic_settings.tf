resource "azurerm_monitor_diagnostic_setting" "oracle_vm" {
  count              = var.is_diagnostic_settings_enabled ? var.database_server_count : 0
  name               = "${var.vm_name}-${count.index}-diag"
  target_resource_id = azurerm_linux_virtual_machine.oracle_vm[count.index].id
  storage_account_id = var.storage_account_id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.oracle_vm[count.index].log_category_types
    content {
      category = each.value
      retention_policy {
        enabled = true
        days    = 30
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

data "azurerm_monitor_diagnostic_categories" "oracle_vm" {
  count       = var.is_diagnostic_settings_enabled ? var.database_server_count : 0
  resource_id = data.azurerm_virtual_machine.oracle_vm[count.index].id
}

data "azurerm_virtual_machine" "oracle_vm" {
  count               = var.database_server_count
  name                = "${var.vm_name}-${count.index}"
  resource_group_name = var.resource_group.name
}
