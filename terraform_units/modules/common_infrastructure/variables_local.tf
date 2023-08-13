locals {
  resource_group_exists = length(var.infrastructure.resource_group.arm_id) > 0
  // If resource ID is specified extract the resourcegroup name from it otherwise read it either from input of create using the naming convention
  rg_name = local.resource_group_exists ? (
    split("/", var.infrastructure.resource_group.arm_id)[4]) : (
    length(var.infrastructure.resource_group.name) > 0 ? (
      var.infrastructure.resource_group.name) : (
      format("%s-%s-%s-%s",
        "rg",
        local.prefix,
        "test",
        var.infrastructure.region
      )
    )
  )

  vnet_oracle_name       = "vnet1"
  database_subnet_name   = "subnet1"
  vnet_oracle_addr       = "10.0.0.0/16"
  database_subnet_prefix = "10.0.0.0/24"

  // Resource group
  prefix = "prefixdummy"
}
