terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.37.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "b0dae312-4fd1-4fec-9d45-4e4e767d4652"

}



resource "azurerm_resource_group" "eagle_tf_rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_storage_account" "eagle_rf_stac" {
 name = "eagle_rf_stac"
 resource_group_name = azurerm_resource_group.eagle_tf_rg.name
 location = azurerm_resource_group.eagle_tf_rg.location
 account_tieraccount_tier = "Standard"
 account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "eagle_tf_vnet" {
  name                = "eagle_tf_vnet"
  location            = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  address_space       = ["10.1.0.0/16", "10.2.0.0/16"]
}

resource "azurerm_subnet" "eagle_tf_pub_subnet" {
  name                 = "eagle_tf_pub_subnet"
  virtual_network_name = azurerm_virtual_network.eagle_tf_vnet.name
  resource_group_name  = azurerm_resource_group.eagle_tf_rg.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_interface" "eagle_tf_nic_internal" {
  count=length(var.vm_names)
  name     = "eagle_tf_nic_internal_${count.index}"
  location = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name

  ip_configuration {
    name                          = "eagle_tf_nic_internal"
    subnet_id                     = azurerm_subnet.eagle_tf_pub_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vmnames" {
  count=length(var.vm_names)

  name                = "eagle-${var.vm_names[count.index]}"
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  location            = azurerm_resource_group.eagle_tf_rg.location
  size                = var.env_vm_size
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
#   boot_diagnostics {
#     enabled = true
#     #storage_uri = azurerm_storage_account.eagle_rf_stac
#   }

  network_interface_ids = [
    #azurerm_network_interface.eagle_tf_nic_internal.id
    azurerm_network_interface.eagle_tf_nic_internal[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-10"
    sku       = "win10-21h2-pro"
    version   = "latest"
  }
 depends_on = [
    azurerm_network_interface.eagle_tf_nic_internal
  ]
  tags = {
    Environment = var.deploy_env[0]
  }
}



