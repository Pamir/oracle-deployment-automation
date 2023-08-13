###############################################################################
#                                                                             #
#                             Resource Group                                  #
#                                                                             #
###############################################################################
output "resource_group" {
  value = data.azurerm_resource_group.rg
}

output "created_resource_group_id" {
  description = "Created resource group ID"
  value       = data.azurerm_resource_group.rg.id
}

output "created_resource_group_name" {
  description = "Created resource group name"
  value       = data.azurerm_resource_group.rg.name
}

output "created_resource_group_subscription_id" {
  description = "Created resource group' subscription ID"
  value       = data.azurerm_resource_group.rg.id
}

###############################################################################
#                                                                             #
#                            Network                                          #
#                                                                             #
###############################################################################
output "network_location" {
  value = data.azurerm_virtual_network.vnet_oracle.location
}

output "db_subnet" {
  value = data.azurerm_subnet.subnet_oracle[0]
}
