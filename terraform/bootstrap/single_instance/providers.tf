terraform {
  required_version = ">=1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.11.0, <4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }

  subscription_id = "14c3937a-502f-407d-b590-bfe86895887e"
  tenant_id       = "2dd6bfd0-1796-4d89-9a2b-974f8c239ce8"
  client_id       = "19587688-3cec-493e-84c7-9a5f712871f5"
  client_secret   = "qaK8Q~x.f9X7EPSo3XKv_xfrlO3Lh.kWu.Nldckf"
}
