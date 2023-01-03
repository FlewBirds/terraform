variable "rg_name" {
  type        = string
  description = "value"
  default     = "eagle_tf_rg"

  validation {
    condition     = length(var.rg_name) > 8 && substr(var.rg_name, 0, 8) == "eagle_tf"
    error_message = "The rg name value must be a valid id as per definition, starting with \"eagle_tf\"."
  }
}

variable "rg_location" {
  type        = string
  description = "location of resource"
  default     = "eastus"
}

variable "vm_names" {
  type = list(string)
  default = ["APPLE", "banana", "Goa"]
  #default = ["APPLE"]
}

variable "address_space_vnet" {

  type = list(string)

  default = ["10.1.0.0/16", "10.2.0.0/16"]

  #type = map

  #  default = {
  #   "Dev" = "10.1.0.0/16"
  #   "QA"  = "10.2.0.0/16"
  #   }

}

variable "address_space_vnet_map" {

  # type = list(string)

  # default = ["10.1.0.0/16", "10.2.0.0/16"]

   type = map

    default = {
     "Dev" = "10.1.0.0/16"
     "QA"  = "10.2.0.0/16"
     }



}




# variable "address_space_vnet" {
#   #default = ["", "10.2.0.0/16", "10.3.0.0/16", "10.4.0.0/16" ]
#     type = map(object({address_space=string}))
#   default = {
#     "Dev" = {
#       address_space = "10.1.0.0/16"
#     },
#     "QA" = {
#       address_space = "10.2.0.0/16"
#     },
#       "Stage" = {
#       address_space = "10.3.0.0/16"
#     },
#     "PROD" = {
#       address_space = "10.4.0.0/16"
#     },
#   }
# }

variable "deploy_env" {
  type    = list(string)
  default = ["Dev", "QA"]
}

variable "env_vm_size" {
  type = map(object({ size = string, enable_accelerated_networking = bool }))
  default = {
    "Dev" = {
      size                          = "Standard_D2s_v3"
      enable_accelerated_networking = false
    },
    "QA" = {
      size                          = "Standard_D2s_v3"
      enable_accelerated_networking = false
    },
    "Stage" = {
      size                          = "Standard_D2as_v4"
      enable_accelerated_networking = false
    },
    "PROD" = {
      size                          = "Standard_DS2_v2"
      enable_accelerated_networking = true
    }
  }

}

variable "tags" {
  type = object({
    Environment   = string
    Owner         = string
    Role_app_type = string
    Role_app      = string
  })
  default = {
    Environment   = "Dev"
    Owner         = "Operations_team"
    Role_app_type = "nodejs"
    Role_app      = "app_vm"
  }
}
variable "vnet_subnet_count" {
  type    = number
  default = 2

}

variable "vnet_cidr_block" {
  type    = list(any)
  default = ["10.1.0.0/16"]
}

variable "billingcode" {
  type    = string
  default = "ACCT8675309"
}

variable "naming_prefix" {
  type    = string
  default = "eagle"
}

variable "organization" {
  type    = string
  default = "flewbirds"
}

variable "project" {
  type    = string
  default = "projectfb"
}

