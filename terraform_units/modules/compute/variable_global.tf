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

variable "client_ip_range" {
  description = "Client IP address range"
}

variable "subscription_id" {
  description = "Subscription ID"
}
