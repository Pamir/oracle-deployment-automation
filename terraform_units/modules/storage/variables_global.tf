variable "naming" {
  description = "Defines the names for the resources"
}

variable "vm" {
  description = "Virtual machine name"
}

variable "resource_group" {
  description = "Details of the resource group"
  default     = {}
}

variable "disk_type" {
  description = "The type of the storage account"
  default     = "Premium_LRS"
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_ZRS", "Premium_LRS", "PremiumV2_LRS", "Premium_ZRS", "StandardSSD_LRS", "UltraSSD_LRS"], var.disk_type)
    error_message = "Allowed values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS, UltraSSD_LRS"
  }
}

variable "database" {
  description = "Details of the database node"
  default = {
    data_disks = [
      {
        count                     = 1
        caching                   = "ReadOnly"
        create_option             = "Empty"
        disk_size_gb              = 1024
        lun                       = 0
        disk_type                 = "Premium_LRS"
        write_accelerator_enabled = false
      },
      {
        count                     = 1
        caching                   = "None"
        create_option             = "Empty"
        disk_size_gb              = 1024
        lun                       = 1
        disk_type                 = "Premium_LRS"
        write_accelerator_enabled = false
      }
    ]
  }
}

variable "role_assignments" {
  description = "Role assignments"
  default     = {}
}

variable "data_disk_locks" {
  type = object({
    name = optional(string, "")
    type = optional(string, "CanNotDelete")
  })
  default = {}
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.data_disk_locks.type)
    error_message = "Lock type must be one of: CanNotDelete, ReadOnly."
  }
}
