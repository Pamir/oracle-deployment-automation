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
