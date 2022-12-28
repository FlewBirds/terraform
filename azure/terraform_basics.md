Terraform commands

terraform plan -out=s1.tfplan

Terraform Datatypes

string: alphanumeric, special characters
bool: ture / flase
number: numbers


Collection types:
object: key-value pairs
map: dictionary
list: array
sets:
any:

variable listofstrings {
    type = list(string)
    default = ["apple", "banana", "Goa"]
}

output listofstrings {
    vlaue = var.listofstrings
}

output listofstrings {
    vlaue = var.listofstrings[3]
}

variable vm_names {
   type = list(string)
   default = ["windows_10_1", "windows_10_2", "windows_10_3", "windows_10_4"]
}

count = lenght(vm_names)

count.index+1

Variables:

setting variable values:

Files: terraform.tfvars, terraform.rfvars.json, *.auto.tfvars
Environment Variables: export TF_VAR_aws_access_key=[ACCESS_KEY]
Commandline: terraform plan -var aws_access_key=[ACCESS_KEY]





split (":","one:two:three")

join (":",["one","two","three"])
data.aws_availability_zones.available.names