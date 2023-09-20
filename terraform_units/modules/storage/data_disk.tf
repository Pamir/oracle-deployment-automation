resource "azurerm_managed_disk" "data_disk" {
  count                = length(local.data_disks)
  name                 = "${var.naming}-${count.index}"
  location             = var.resource_group.location
  resource_group_name  = var.resource_group.name
  storage_account_type = var.disk_type
  create_option        = "Empty"
  disk_size_gb         = 1024

  tags = local.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count                     = length(local.data_disks)
  managed_disk_id           = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id        = var.vm.id
  caching                   = local.data_disks[count.index].caching
  write_accelerator_enabled = local.data_disks[count.index].write_accelerator_enabled
  lun                       = local.data_disks[count.index].lun
}

data "azurerm_managed_disk" "data_disk" {
  count               = length(local.data_disks)
  name                = azurerm_managed_disk.data_disk[count.index].name
  resource_group_name = var.resource_group.name
}
