#########################################################################################
#                                                                                       #
#  Network Security Group                                                               #
#                                                                                       #
#########################################################################################
resource "azurerm_network_security_group" "blank" {
  name                = "blank"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "ssh" {
  subnet_id                 = azurerm_subnet.subnet_oracle[0].id
  network_security_group_id = azurerm_network_security_group.blank.id
}