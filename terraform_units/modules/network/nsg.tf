#########################################################################################
#                                                                                       #
#  Network Security Group                                                               #
#                                                                                       #
#########################################################################################
resource "azurerm_network_security_group" "allow_ssh" {
  name                = "allow_ssh"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "ssh" {
  subnet_id                 = azurerm_subnet.subnet_oracle[0].id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}
