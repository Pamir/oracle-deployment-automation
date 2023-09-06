#########################################################################################
#                                                                                       #
#  Subscription                                                                         #
#                                                                                       #
#########################################################################################
data "azurerm_subscription" "current" {}

#########################################################################################
#                                                                                       #
#  Resource Group                                                                       #
#                                                                                       #
#########################################################################################
resource "azurerm_resource_group" "rg" {
  count    = local.resource_group_exists ? 0 : 1
  name     = local.rg_name
  location = var.infrastructure.region
  tags     = var.infrastructure.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

data "azurerm_resource_group" "rg" {
  name = local.rg_name

  depends_on = [azurerm_resource_group.rg]
}

#########################################################################################
#                                                                                       #
#  Diagnostic Settings                                                                  #
#                                                                                       #
#########################################################################################
resource "azurerm_storage_account" "diagnostic" {
  count               = var.is_diagnostic_settings_enabled ? 1 : 0
  name                = "${local.prefix}diag${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

data "azurerm_storage_account" "diagnostic" {
  count               = var.is_diagnostic_settings_enabled ? 1 : 0
  name                = azurerm_storage_account.diagnostic[count.index].name
  resource_group_name = data.azurerm_resource_group.rg.name

  depends_on = [azurerm_storage_account.diagnostic]
}

resource "random_string" "suffix" {
  length  = 14
  special = false
  upper   = false
}
