locals {
  infrastructure = {
    region = coalesce(var.location, try(var.infrastructure.region, ""))
    resource_group = {
      name = try(
        coalesce(
          var.resourcegroup_name,
          try(var.infrastructure.resource_group.name, "")
        ),
        ""
      )
      arm_id = try(
        coalesce(
          var.resourcegroup_arm_id,
          try(var.infrastructure.resource_group.arm_id, "")
        ),
        ""
      )
    }
    tags = try(
      coalesce(
        var.resourcegroup_tags,
        try(var.infrastructure.tags, {})
      ),
      {}
    )
  }
}
