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
#  Virtual Network                                                                      #
#                                                                                       #
#########################################################################################
resource "azurerm_virtual_network" "vnet_oracle" {
  count               = local.vnet_oracle_exists ? 0 : 1
  name                = local.vnet_oracle_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = [local.vnet_oracle_addr]
}

data "azurerm_virtual_network" "vnet_oracle" {
  count               = local.vnet_oracle_exists ? 0 : 1
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
  count                = local.subnet_oracle_exists ? 0 : 1
  name                 = local.database_subnet_name
  resource_group_name  = data.azurerm_virtual_network.vnet_oracle[count.index].resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_oracle[count.index].name
  address_prefixes     = [local.database_subnet_prefix]
}

data "azurerm_subnet" "subnet_oracle" {
  count                = local.subnet_oracle_exists ? 0 : 1
  name                 = local.database_subnet_name
  resource_group_name  = data.azurerm_virtual_network.vnet_oracle[count.index].resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_oracle[count.index].name

  depends_on = [azurerm_subnet.subnet_oracle]
}

#########################################################################################
#                                                                                       #
#  Network Security Group                                                               #
#                                                                                       #
#########################################################################################
resource "azurerm_network_security_group" "allow_ssh" {
  name                = "allow_ssh"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "ssh" {
  subnet_id                 = azurerm_subnet.subnet_oracle[0].id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}
