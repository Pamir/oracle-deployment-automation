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

output "target_storage_account_sas" {
  description = "Storage account SAS used for diagnostics"
  value       = var.is_diagnostic_settings_enabled ? data.azurerm_storage_account_sas.diagnostic[0].sas : ""
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = var.is_diagnostic_settings_enabled && var.diagnostic_target == "Log_Analytics_Workspace" ? data.azurerm_log_analytics_workspace.diagnostic[0].id : null
}

output "eventhub_authorization_rule_id" {
  description = "ID of an Event Hub authorization rule"
  value       = var.is_diagnostic_settings_enabled && var.diagnostic_target == "Event_Hubs" ? azurerm_eventhub_namespace_authorization_rule.diagnostic[0].id : null
}

output "partner_solution_id" {
  description = "Partner solution ID"
  value       = var.is_diagnostic_settings_enabled && var.diagnostic_target == "Partner_Solutions" ? azurerm_new_relic_monitor.diagnostic[0].id : null
}

output "diagnostic_target" {
  description = "The destination type of the diagnostic settings"
  value       = var.diagnostic_target
}
