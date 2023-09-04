module "common_infrastructure" {
  source = "../../../terraform_units/modules/common_infrastructure"

  infrastructure = local.infrastructure
}

module "vm" {
  source = "../../../terraform_units/modules/compute"

  subscription_id = module.common_infrastructure.current_subscription.subscription_id
  resource_group  = module.common_infrastructure.resource_group
  vm_name         = "vm"
  public_key      = var.ssh_key
  sid_username    = "oracle"
  nic_id          = module.network.nics_oracledb[0].id
}

module "network" {
  source = "../../../terraform_units/modules/network"

  resource_group = module.common_infrastructure.resource_group
}

module "storage" {
  source = "../../../terraform_units/modules/storage"

  resource_group = module.common_infrastructure.resource_group
  naming         = "oracle"
  vm             = module.vm.vm[0]
}
