variable "database" {}
variable "infrastructure" {}
variable "options" {}

variable "subscription_id" {
  description = "The subscription ID where the policy will be deployed"
}

variable "resource_group" {
  description = "Details of the resource group"
  default     = {}
}

variable "naming" {
  description = "Defines the names for the resources"
}

variable "db_subnet" {
  description = "Information about Oracle db subnet"
}

variable "deploy_application_security_groups" {
  description = "Defines if application security groups should be deployed"
  default     = false
}

variable "database_server_count" {
  description = "The number of database servers"
  default     = 1
}

variable "sid_username" {
  description = "SDU username"
}

variable "use_secondary_ips" {
  description = "Defines if secondary IPs are used for the SAP Systems virtual machines"
  default     = false
}

variable "database_vm_db_nic_ips" {
  description = "If provided, the database tier virtual machines will be configured using the specified IPs"
  default     = [""]
}

variable "database_vm_db_nic_secondary_ips" {
  description = "If provided, the database tier virtual machines will be configured using the specified IPs as secondary IPs"
  default     = [""]
}

variable "public_key" {
  description = "Public key used for authentication in ssh-rsa format"
}

variable "deployer_disk_type" {
  description = "The type of the disk for the deployer VM"
  default     = "Premium_LRS"
}

variable "deployer" {
  description = "Details of deployer"
  default = {
    "disk_type" : "Premium_LRS"
  }
}

variable "vm_oracle_name" {
  description = "The name of the Oracle VM"
}

variable "storage_account_type" {
  description = "The type of the storage account"
  default     = "Premium_LRS"
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_ZRS", "Premium_LRS", "PremiumV2_LRS", "Premium_ZRS", "StandardSSD_LRS", "UltraSSD_LRS"], var.storage_account_type)
    error_message = "Allowed values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS, UltraSSD_LRS"
  }
}
