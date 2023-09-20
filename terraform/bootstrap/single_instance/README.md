# Introduction to Deploying Single VM for Oracle

## Background

This guide describes how to get started with implementing Oracle Database on Azure VM. In the guide it is assumed that you will be using Terraform and Ansible to deploy Oracle on Azure VMs.

The repo at present contains code and details for the following:

- Deploy single VM for Oracle in the VNET.

## Prerequisites

1. Azure Active Directory Tenant.
2. Minimum 1 subscription, for when deploying VMs. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/en-us/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio) before you begin.

## Authenticate Terraform to Azure

To use Terraform commands against your Azure subscription, you must first authenticate Terraform to that subscription. [This doc](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash) describes how to authenticate Terraform to your Azure subscription.

## Getting started

- Fork this repo to your own GitHub organization, you should not create a direct clone of the repo. Pull requests based off direct clones of the repo will not be allowed.
- Clone the repo from your own GitHub organization to your developer workstation.
- Review your current configuration to determine what scenario applies to you. We have guidance that will help deploy Oracle VMs in your subscription.

### How to deploy single VM for Oracle in the VNET

In this module, you will deploy single virtual machine in the virtual network.

<img src="images/single_vm.png" />

To deploy single Oracle instance on the VM, you can use **single_instance** module in this repo. The module is located on `terraform/bootstrap/single_instance` directory.

Before using this module, you have to create your own ssh key to deploy and connect the virtual machine you will create.

```bash
$ ssh-keygen

$ ls -lha ~/.ssh/
-rw-------   1 yourname  staff   2.6K  8 17  2023 id_rsa
-rw-r--r--   1 yourname  staff   589B  8 17  2023 id_rsa.pub
```

Next, you go to `terraform/bootstrap/single_instance` directory and create `fixtures.tfvars` file, which contains ssh public key used for deploying a virtual machine on Azure.

This is a sample `fixtures.tfvars` file.

```tf:fixtures.tfvars
ssh_key = "ssh-rsa xxxxxxxxxxxxxx.local"
```

Then, you execute below Terraform commands. When you deploy resources to Azure, you have to indicate `fixtures.tfvars` as a variable file, which contains the ssh public key.

```
$ pwd
/path/to/this/repo/oracle-deployment-automation/terraform/bootstrap/single_instance

$ terraform init

$ terraform plan -var-file=fixtures.tfvars

$ terraform apply -var-file=fixtures.tfvars
```

Finally, you can connect to the virtual machine with ssh private key. While deploying resources, a public ip address is generated and attached to the virtual machine, so that you can connect to the virtual machine with this IP address. The username is `oracle`, which is fixed in `terraform/bootstrap/single_instance/module.tf`.

```
$ ssh oracle@<PUBLIC_IP_ADDRESS>
```

### How to enable diagnostic settings

To enable diagnostic settings, you have to set `is_diagnostic_settings_enabled` **true** in **common_infrastructure** module.

```
module "common_infrastructure" {
  source = "../../../terraform_units/modules/common_infrastructure"

  infrastructure                 = local.infrastructure
  is_diagnostic_settings_enabled = true  // ← This one
}
```

### How to assign roles in a specific scope

To assign roles, you must set `role_assignments` value in each module.

For example, in order to assign `Contributor` role in a subscription scope, you have to set the value like below.

```
module "common_infrastructure" {
  source = "../../../terraform_units/modules/common_infrastructure"

  ・・・

  role_assignments = {
    role_assignment_1 = {
      name                             = "Contributor"
      skip_service_principal_aad_check = false
    }
  }
}
```

Also, you can assign roles in the specific scope. If you want to assign `Virtual Machine Contributor` role in the VM scope, you should set the below value.

```
module "vm" {
  source = "../../../terraform_units/modules/compute"
  ・・・
  role_assignments = {
    role_assignment_1 = {
      name                             = "Virtual Machine Contributor"
      skip_service_principal_aad_check = false
    }
  }
}
```

Role names you can assign can be referred in [this document](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).
