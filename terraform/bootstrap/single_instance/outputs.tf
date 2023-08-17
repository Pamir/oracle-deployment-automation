###############################################################################
#                                                                             #
#                             Resource Group                                  #
#                                                                             #
###############################################################################
output "resource_group" {
  value = module.common_infrastructure.resource_group
}

output "created_resource_group_id" {
  description = "Created resource group ID"
  value       = module.common_infrastructure.resource_group.id
}

output "created_resource_group_name" {
  description = "Created resource group name"
  value       = module.common_infrastructure.resource_group.name
}

output "created_resource_group_subscription_id" {
  description = "Created resource group' subscription ID"
  value       = module.common_infrastructure.resource_group.id
}

###############################################################################
#                                                                             #
#                            Network                                          #
#                                                                             #
###############################################################################
output "network_location" {
  value = module.common_infrastructure.network_location
}

output "db_subnet" {
  value = module.common_infrastructure.db_subnet
}
