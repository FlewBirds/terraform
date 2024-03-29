locals {
  common_tags = {
    company      = var.organization
    project      = "${var.organization}-${var.project}"
    billing_code = var.billingcode
  }
  name_prefix = "${var.naming_prefix}-dev"
  #env = "Dev"
}

resource "azurerm_resource_group" "eagle_tf_rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_storage_account" "eaglerfstac" {
  name                     = "eaglerfstac"
  resource_group_name      = azurerm_resource_group.eagle_tf_rg.name
  location                 = azurerm_resource_group.eagle_tf_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
  
resource "azurerm_virtual_network" "eagle_tf_vnet" {
  count               = length(var.deploy_env)
  #for_each = var.address_space_vnet_map
  name                = "eagle_tf_vnet_${var.deploy_env[count.index]}"
  #name = "eagle_tf_vnet_${each.key}"
  location            = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  #address_space       = var.address_space_vnet[var.deploy_env[*]]
  # address_space       = ["10.1.0.0/16"]
  #address_space = [var.address_space_vnet[count.index]]
    #address_space = address_space_vnet_map
  #address_space = "${lookup(var.address_space_vnet_map, element(var.deploy_env, count.index))}"
  address_space = ["${lookup(var.address_space_vnet_map, element(var.deploy_env, count.index))}"]
  #address_space = lookup(var.address_space_vnet_map, var.deploy_env)
}

resource "azurerm_subnet" "eagle_tf_pub_subnet" {
  count = length(var.deploy_env)
  name                 = "eagle_tf_pub_subnet_${var.deploy_env[count.index]}"
  #name                 = "eagle_tf_pub_subnet"
  virtual_network_name = azurerm_virtual_network.eagle_tf_vnet[count.index].name
  resource_group_name  = azurerm_resource_group.eagle_tf_rg.name
  #address_prefixes     = ["10.1.1.0/24"]
  address_prefixes = [cidrsubnet("${lookup(var.address_space_vnet_map, element(var.deploy_env, count.index))}", 8,1)]
  depends_on = [
    azurerm_virtual_network.eagle_tf_vnet
  ]
}

# resource "azurerm_public_ip" "vm_public_ip" {
#   count = length(var.vm_names)
#   name                = "vm_public_ip_${lower(var.vm_names[count.index])}"
#   resource_group_name = azurerm_resource_group.eagle_tf_rg.name
#   location            = azurerm_resource_group.eagle_tf_rg.location
#   allocation_method   = "Dynamic"
# }
# resource "azurerm_network_interface" "eagle_tf_nic_internal" {

#   count                         = length(var.vm_names)
#   name                          = "eagle_tf_nic_internal_${lower(var.vm_names[count.index])}"
#   location                      = azurerm_resource_group.eagle_tf_rg.location
#   resource_group_name           = azurerm_resource_group.eagle_tf_rg.name
#   enable_accelerated_networking = var.env_vm_size["Dev"].enable_accelerated_networking

#   ip_configuration {
#     #count         = length(var.vm_names)
#     name                          = "eagle_tf_nic_internal"
#     subnet_id                     = azurerm_subnet.eagle_tf_pub_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     # public_ip_address_id = [azurerm_public_ip.vm_public_ip[var.vm_names[count.index]]]
#   }
# depends_on = [
#   azurerm_public_ip.vm_public_ip
# ]
# }

# resource "azurerm_windows_virtual_machine" "vmnames" {
#   count = length(var.vm_names)

#   name                = "${var.naming_prefix}-${lower(var.vm_names[count.index])}"
#   #name = lower(var.vm_names[count.index])
#   resource_group_name = azurerm_resource_group.eagle_tf_rg.name
#   location            = azurerm_resource_group.eagle_tf_rg.location
#   size                = var.env_vm_size["Dev"].size
#   admin_username      = "adminuser"
#   admin_password      = var.admin_password
#   #enable_boot_diagnostics = var.env_vm_size["Dev"].enable_boot_diagnostics
#   #  boot_diagnostics {
#   #    enabled = var.env_vm_size["Dev"].enable_boot_diagnostics
#   #    storage_uri = azurerm_storage_account.eaglerfstac
#   #  }

#   network_interface_ids = [
#     #azurerm_network_interface.eagle_tf_nic_internal.id
#     azurerm_network_interface.eagle_tf_nic_internal[count.index].id
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "microsoftwindowsdesktop"
#     offer     = "windows-10"
#     sku       = "win10-21h2-pro"
#     version   = "latest"
#   }
#   depends_on = [
#     azurerm_network_interface.eagle_tf_nic_internal
#   ]
#   # tags = var.tags
#   tags = merge(local.common_tags, {
#   Name = "${local.name_prefix}-vm" })

#   lifecycle {

#     # ignore_changes = [
#     #   # Ignore changes to tags, e.g. because a management agent
#     #   # updates these based on some ruleset managed elsewhere.
#     #   tags, size
#     #]
#     create_before_destroy = true

#   }
# }





