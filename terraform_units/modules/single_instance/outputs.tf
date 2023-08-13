output "nics_oracledb" {
  value = azurerm_network_interface.oracle_db
}

output "db_server_ips" {
  value = azurerm_network_interface.oracle_db[*].private_ip_addresses[0]
}
