###############################################################################
#                                                                             #
#                             Subscription                                    #
#                                                                             #
###############################################################################
output "current_subscription" {
  value = data.azurerm_subscription.current
}

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

output "is_diagnostic_settings_enabled" {
  description = "Whether diagnostic settings are enabled"
  value       = var.is_diagnostic_settings_enabled
}

output "target_storage_account_id" {
  description = "Storage account ID used for diagnostics"
  value       = var.is_diagnostic_settings_enabled ? data.azurerm_storage_account.diagnostic[0].id : ""
}
