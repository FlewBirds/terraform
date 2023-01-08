locals {
  prefix = "eagle_vm_larvel"
}
resource "azurerm_public_ip" "eagle_vm_larvel_public_ip" {
  name                = "eagle_vm_larvel_public_ip"
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  location            = azurerm_resource_group.eagle_tf_rg.location
  sku = "Standard"
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "eagle_vm_larvel-nic" {
  name                = "${local.prefix}-nic"
  location            = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.eagle_tf_pub_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.eagle_vm_larvel_public_ip.id
  }
  depends_on = [
    azurerm_public_ip.eagle_vm_larvel_public_ip
  ]
}

# resource "azurerm_network_interface_application_security_group_association" "eagle_nic_nsg_asso" {
#     network_interface_id = azurerm_network_interface.eagle_vm_larvel-nic.id
#     application_security_group_id = azurerm_network_security_group.eagle_tf_azs_nsg.id
# }

# resource "azurerm_virtual_machine" "eagle_vm_larvel" {
#   name                  = "${local.prefix}-vm"
#   location            = azurerm_resource_group.eagle_tf_rg.location
#   resource_group_name = azurerm_resource_group.eagle_tf_rg.name
#   network_interface_ids = [azurerm_network_interface.eagle_vm_larvel-nic.id]
#   vm_size               = "Standard_DS1_v2"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true

#   # Uncomment this line to delete the data disks automatically when deleting the VM
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts-gen2"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "hostname"
#     admin_username = "testadmin"
#     admin_password = "Password1234!"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
#   tags = {
#     environment = "dev-${local.prefix}"
#   }

#   depends_on = [
#     azurerm_network_interface.eagle_vm_larvel-nic
#   ]
# }

resource "azurerm_windows_virtual_machine" "eagle_vm_larvel" {
  name                = "eaglewinlarvel"
  location            = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.eagle_vm_larvel-nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # source_image_reference {
  #   publisher = "MicrosoftWindowsServer"
  #   offer     = "WindowsServer"
  #   sku       = "2016-Datacenter"
  #   version   = "latest"
  # }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-10"
    sku       = "win10-21h2-pro"
    version   = "latest"
  }

   tags = {
    environment = "dev-${local.prefix}"
  }

  depends_on = [
    azurerm_network_interface.eagle_vm_larvel-nic
  ]
}