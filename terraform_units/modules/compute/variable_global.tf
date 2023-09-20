variable "database_server_count" {
  description = "The number of database servers"
  default     = 1
}

variable "vm_name" {
  description = "The name of the Oracle VM"
}

variable "resource_group" {
  description = "Details of the resource group"
  default     = {}
}

variable "sid_username" {
  description = "SDU username"
}

variable "public_key" {
  description = "Public key used for authentication in ssh-rsa format"
}

variable "deployer" {
  description = "Details of deployer"
  default = {
    "disk_type" : "Premium_LRS"
  }
}

variable "options" {
  description = "Options for the Oracle deployment"
  default     = {}
}

variable "database" {
  description = "Details of the database node"
  default = {
    authentication = {
      type = "key"
    }
  }
}

variable "nic_id" {
  description = "value of the nic id"
}

variable "subscription_id" {
  description = "Subscription ID"
}

variable "assign_subscription_permissions" {
  description = "Assign permissions on the subscription"
  type        = bool
}

variable "aad_system_assigned_identity" {
  description = "AAD system assigned identity"
  type        = bool
}

variable "skip_service_principal_aad_check" {
  description = "If the principal_id is a newly provisioned `Service Principal` set this value to true to skip the Azure Active Directory check which may fail due to replication lag."
  default     = true
}

variable "storage_account_id" {
  description = "Storage account ID used for diagnostics"
  type        = string
  default     = null
}

variable "storage_account_sas_token" {
  description = "Storage account SAS token used for diagnostics"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "ID of an Event Hub authorization rule"
  type        = string
  default     = null
}

variable "partner_solution_id" {
  description = "Value of the partner solution ID"
  default     = null
}

variable "is_diagnostic_settings_enabled" {
  description = "Whether diagnostic settings are enabled"
  default     = false
}

variable "diagnostic_target" {
  description = "The destination type of the diagnostic settings"
  default     = "Log_Analytics_Workspace"
  validation {
    condition     = contains(["Log_Analytics_Workspace", "Storage_Account", "Event_Hubs", "Partner_Solutions"], var.diagnostic_target)
    error_message = "Allowed values are Log_Analytics_Workspace, Storage_Account, Event_Hubs, Partner_Solutions"
  }
}

variable "role_assignments" {
  description = "Role assignments"
  default     = {}
}
