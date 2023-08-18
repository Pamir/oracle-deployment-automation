locals {
  database_ips = (var.use_secondary_ips) ? (
    flatten(concat(local.database_primary_ips, local.database_secondary_ips))) : (
    local.database_primary_ips
  )

  // Subnet IP Offsets
  // Note: First 4 IP addresses in a subnet are reserved by Azure
  oracle_ip_offsets = {
    oracle_vm = 5 + 1
  }

  database_primary_ips = [
    {
      name                          = "IPConfig1"
      subnet_id                     = var.db_subnet.id
      nic_ips                       = var.database_vm_db_nic_ips
      private_ip_address_allocation = var.database.use_DHCP ? "Dynamic" : "Static"
      offset                        = 0
      primary                       = true
    }
  ]

  database_secondary_ips = [
    {
      name                          = "IPConfig2"
      subnet_id                     = var.db_subnet.id
      nic_ips                       = var.database_vm_db_nic_secondary_ips
      private_ip_address_allocation = var.database.use_DHCP ? "Dynamic" : "Static"
      offset                        = var.database_server_count
      primary                       = false
    }
  ]

  deployer = {
    disk_type = var.deployer_disk_type
  }

  data_disks = flatten(
    [
      for disk in var.database.data_disks : [
        for i in range(0, disk.count) : {
          name                      = "${var.vm_oracle_name}-datadisk${i}"
          caching                   = disk.caching
          create_option             = disk.create_option
          disk_size_gb              = disk.disk_size_gb
          lun                       = disk.lun + i
          managed_disk_type         = disk.managed_disk_type
          storage_account_type      = disk.storage_account_type
          write_accelerator_enabled = disk.write_accelerator_enabled
        }
      ]
    ]
  )

  vm_oracle_name = "oraclevm"

  vm_oracle_arm_id = try(local.vm_oracle_name.arm_id, "")
  vm_oracle_exists = length(local.vm_oracle_arm_id) > 0

  enable_ultradisk = false
  oracle_sku       = "Standard_D4s_v3"

  sid_auth_type        = try(var.database.authentication.type, "key")
  enable_auth_password = local.sid_auth_type == "password"
  enable_auth_key      = local.sid_auth_type == "key"

  tags = {}
}
