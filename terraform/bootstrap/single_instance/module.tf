module "common_infrastructure" {
  source = "../../../terraform_units/modules/common_infrastructure"

  infrastructure                 = local.infrastructure
  is_diagnostic_settings_enabled = true
  diagnostic_target              = "Log_Analytics_Workspace"
}

module "vm" {
  source = "../../../terraform_units/modules/compute"

  subscription_id = module.common_infrastructure.current_subscription.subscription_id
  resource_group  = module.common_infrastructure.resource_group
  vm_name         = "vm"
  public_key      = var.ssh_key
  sid_username    = "oracle"
  nic_id          = module.network.nics_oracledb[0].id

  aad_system_assigned_identity    = false
  assign_subscription_permissions = true

  is_diagnostic_settings_enabled = module.common_infrastructure.is_diagnostic_settings_enabled
  diagnostic_target              = module.common_infrastructure.diagnostic_target
  storage_account_id             = module.common_infrastructure.target_storage_account_id
  storage_account_sas_token      = module.common_infrastructure.target_storage_account_sas
  log_analytics_workspace_id     = module.common_infrastructure.log_analytics_workspace_id
  eventhub_authorization_rule_id = module.common_infrastructure.eventhub_authorization_rule_id
  partner_solution_id            = module.common_infrastructure.partner_solution_id
}

module "network" {
  source = "../../../terraform_units/modules/network"

  resource_group                 = module.common_infrastructure.resource_group
  is_diagnostic_settings_enabled = module.common_infrastructure.is_diagnostic_settings_enabled
  diagnostic_target              = module.common_infrastructure.diagnostic_target
  storage_account_id             = module.common_infrastructure.target_storage_account_id
  log_analytics_workspace_id     = module.common_infrastructure.log_analytics_workspace_id
  eventhub_authorization_rule_id = module.common_infrastructure.eventhub_authorization_rule_id
  partner_solution_id            = module.common_infrastructure.partner_solution_id
}

module "storage" {
  source = "../../../terraform_units/modules/storage"

  resource_group = module.common_infrastructure.resource_group
  naming         = "oracle"
  vm             = module.vm.vm[0]
}
