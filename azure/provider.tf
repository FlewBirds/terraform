terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.37.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "fb-rg"
    storage_account_name = "fbtfstate"
    container_name       = "tfstate"
    key                  = "statefile/terraform.tfstate"
  }
}

# Requirements for Backend State
#Storage Account Name:
#key: path to the statefile
#access_key: storage access key



provider "azurerm" {
  features {

  }
  subscription_id = "b0dae312-4fd1-4fec-9d45-4e4e767d4652"

}