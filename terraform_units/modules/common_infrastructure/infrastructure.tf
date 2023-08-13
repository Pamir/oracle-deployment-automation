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
#  Virtual Network                                                                      #
#                                                                                       #
#########################################################################################
resource "azurerm_virtual_network" "vnet_oracle" {
  name                = local.vnet_oracle_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = [local.vnet_oracle_addr]
}

data "azurerm_virtual_network" "vnet_oracle" {
  name                = local.vnet_oracle_name
  resource_group_name = local.rg_name

  depends_on = [azurerm_virtual_network.vnet_oracle]
}

#########################################################################################
#                                                                                       #
#  DB Subnet variables                                                                  #
#                                                                                       #
#########################################################################################
resource "azurerm_subnet" "subnet_oracle" {
  count                = 1
  name                 = local.database_subnet_name
  resource_group_name  = data.azurerm_virtual_network.vnet_oracle.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_oracle.name
  address_prefixes     = [local.database_subnet_prefix]
}

data "azurerm_subnet" "subnet_oracle" {
  count                = 1
  name                 = local.database_subnet_name
  resource_group_name  = data.azurerm_virtual_network.vnet_oracle.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_oracle.name

  depends_on = [azurerm_subnet.subnet_oracle]
}
