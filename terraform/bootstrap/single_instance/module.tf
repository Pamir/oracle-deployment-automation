module "common_infrastructure" {
  source = "../../../terraform_units/modules/common_infrastructure"

  infrastructure = local.infrastructure
  naming         = "ora"
}

module "oracle_vm" {
  source = "../../../terraform_units/modules/single_instance"

  resource_group = module.common_infrastructure.resource_group
  naming         = "ora"
  db_subnet      = module.common_infrastructure.db_subnet
  vm_oracle_name = "oraclevm"
  sid_username   = "oracle"
  public_key     = var.ssh_key
  infrastructure = var.infrastructure
  database       = var.database
  options        = var.options
}
