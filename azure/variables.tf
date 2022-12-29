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
    default = ["apple", "banana", "Goa"]
}

variable "deploy_env" {
  type = list(string)
  default = [ "Dev", "QA", "Stage", "PROD" ]
}

variable "env_vm_size" {
  type = map(object({size=string, enable_accelerated_networking=bool}))
  default = {
    "Dev" = {
      size = "Standard_B2ms"
      enable_accelerated_networking = false
    },
    "QA" = {
      size = "Standard_D2s_v3"
      enable_accelerated_networking = false
    },
      "Stage" = {
      size = "Standard_D2as_v4"
      enable_accelerated_networking = false
    },
    "PROD" = {
      size = "Standard_DS2_v2"
      enable_accelerated_networking = true
    }
  }
  
}

variable "tags" {
 type = object({
    Environment = string
    Owner = string
    Role_app_type = string
    Role_app = string
 })
  default = {
    Environment = "Dev"
    Owner = "Operations_team"
    Role_app_type = "nodejs"
    Role_app = "app_vm"
  }
}