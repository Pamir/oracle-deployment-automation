variable "resource_group" {
  description = "Details of the resource group"
  default     = {}
}

variable "database_nic_ips" {
  description = "If provided, the database tier virtual machines will be configured using the specified IPs"
  default     = [""]
}

variable "database" {
  description = "Details of the database node"
  default = {
    use_DHCP = true
    authentication = {
      type = "key"
    }
  }
}

variable "database_nic_secondary_ips" {
  description = "If provided, the database tier virtual machines will be configured using the specified IPs as secondary IPs"
  default     = [""]
}

variable "database_server_count" {
  description = "The number of database servers"
  default     = 1
}

variable "use_secondary_ips" {
  description = "Defines if secondary IPs are used for the SAP Systems virtual machines"
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

variable "storage_account_id" {
  description = "Storage account ID used for diagnostics"
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

variable "role_assignments_nic" {
  description = "Role assignments scoped to the network interface"
  default     = {}
}

variable "role_assignments_pip" {
  description = "Role assignments scoped to the public IP address"
  default     = {}
}

variable "role_assignments_nsg" {
  description = "Role assignments scoped to the network security group"
  default     = {}
}

variable "role_assignments_vnet" {
  description = "Role assignments scoped to the virtual network"
  default     = {}
}

variable "role_assignments_subnet" {
  description = "Role assignments scoped to the subnet"
  default     = {}
}

variable "tags" {
  description = "Tags to be added to the resources"
  default     = {}
}