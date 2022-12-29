output "azurerm_network_interface" {
    value = azurerm_network_interface.eagle_tf_nic_internal[*].id
   
}

output "azurerm_windows_virtual_machine" {
    value = azurerm_windows_virtual_machine.vmnames[*].name
}