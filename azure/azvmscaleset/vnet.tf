resource "azurerm_resource_group" "eagle_tf_rg" {
  name     = "eagle_tf_rg"
  location = "eastus"
}

resource "azurerm_storage_account" "eaglerfstac" {
  name                     = "eaglerfstac"
  resource_group_name      = azurerm_resource_group.eagle_tf_rg.name
  location                 = azurerm_resource_group.eagle_tf_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_security_group" "eagle_tf_azs_nsg" {
  name                = "eagle_tf_azs_nsg"
  location            = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name

 security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "eagle_tf_nsg_asso" {
  subnet_id                 = azurerm_subnet.eagle_tf_pub_subnet.id
  network_security_group_id = azurerm_network_security_group.eagle_tf_azs_nsg.id
  depends_on = [
    azurerm_network_security_group.eagle_tf_azs_nsg
  ]
}


resource "azurerm_subnet" "eagle_tf_pub_subnet" {
  
    name           = "eagle_tf_pub_larvel"
    address_prefixes = ["10.0.1.0/24"]
    resource_group_name = azurerm_resource_group.eagle_tf_rg.name
    virtual_network_name = azurerm_virtual_network.eagle_tf_azs_vnet.name

}
resource "azurerm_virtual_network" "eagle_tf_azs_vnet" {
  name                = "eagle_tf_azs_vnet"
  location            = azurerm_resource_group.eagle_tf_rg.location
  resource_group_name = azurerm_resource_group.eagle_tf_rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = []

  tags = {
    environment = "dev"
  }
}