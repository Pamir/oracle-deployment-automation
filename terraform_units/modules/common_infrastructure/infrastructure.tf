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
