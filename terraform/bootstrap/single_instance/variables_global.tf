variable "infrastructure" {
  description = "Details of the Azure infrastructure to deploy the SAP landscape into"
  default     = {}
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

variable "options" {
  description = "Options for the Oracle deployment"
  default     = {}
}

variable "vnet_arm_id" {
  description = "ARM ID of the VNet to be deployed"
  default     = ""
}

variable "subnet_arm_id" {
  description = "ARM ID of the subnet to be deployed"
  default     = ""
}
