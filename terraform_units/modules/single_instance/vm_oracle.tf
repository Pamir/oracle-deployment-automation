#############################################################################
# RESOURCES
#############################################################################

#########################################################################################
#                                                                                       #
#  Primary Network Interface                                                            #
#                                                                                       #
#########################################################################################
resource "azurerm_network_interface" "oracle_db" {
  count = 1
  name  = "oraclevmnic1"

  location                      = var.resource_group.location
  resource_group_name           = var.resource_group.name
  enable_accelerated_networking = true

  dynamic "ip_configuration" {
    iterator = pub
    for_each = local.database_ips
    content {
      name      = pub.value.name
      subnet_id = pub.value.subnet_id
      private_ip_address = try(pub.value.nic_ips[count.index],
        var.database.use_DHCP ? (
          null) : (
          cidrhost(
            var.db_subnet.address_prefixes[0],
            tonumber(count.index) + local.oracle_ip_offsets.oracle_db_vm + pub.value.offset
          )
        )
      )
      private_ip_address_allocation = length(try(pub.value.nic_ips[count.index], "")) > 0 ? (
        "Static") : (
        pub.value.private_ip_address_allocation
      )

      public_ip_address_id = azurerm_public_ip.vm_pip.id

      primary = pub.value.primary
    }
  }

  tags = local.tags
}

resource "azurerm_public_ip" "vm_pip" {
  name                = "vmpip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"

  tags = local.tags
}

#########################################################################################
#                                                                                       #
#  Linux Virtual Machine                                                                #
#                                                                                       #
#########################################################################################
resource "azurerm_linux_virtual_machine" "oracle_vm" {
  count               = var.database_server_count
  name                = "${var.name}-${count.index}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  admin_username                  = var.sid_username
  disable_password_authentication = !local.enable_auth_password

  admin_ssh_key {
    username   = var.sid_username
    public_key = var.public_key
  }

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "79-gen2"
    version   = "7.9.36"
  }

  os_disk {
    name                   = "osdisk"
    caching                = "ReadWrite"
    storage_account_type   = var.deployer.disk_type
    disk_encryption_set_id = try(var.options.disk_encryption_set_id, null)
    disk_size_gb           = 128
  }

  network_interface_ids = [azurerm_network_interface.oracle_db[0].id]

  size = local.oracle_sku

  additional_capabilities {
    ultra_ssd_enabled = local.enable_ultradisk
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      // Ignore changes to computername
      tags,
      computer_name
    ]
  }
}

#########################################################################################
#                                                                                       #
#  Data Disk                                                                            #
#                                                                                       #
#########################################################################################
resource "azurerm_managed_disk" "data_disk" {
  count                = length(local.data_disks)
  name                 = "${var.naming}-${count.index}"
  location             = var.resource_group.location
  resource_group_name  = var.resource_group.name
  storage_account_type = var.type
  create_option        = "Empty"
  disk_size_gb         = 1024

  tags = local.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count                     = length(local.data_disks)
  managed_disk_id           = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id        = azurerm_linux_virtual_machine.oracle_vm[0].id
  caching                   = local.data_disks[count.index].caching
  write_accelerator_enabled = local.data_disks[count.index].write_accelerator_enabled
  lun                       = local.data_disks[count.index].lun
}
