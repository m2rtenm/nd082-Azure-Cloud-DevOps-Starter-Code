variable "prefix" {
    description = "User can define a suitable prefix for certain resources"
    default = "Ubuntu"
}

variable "resource_group_name" {
  description = "Resource group name from Packer to match with the resource group name described in Terraform"
  default = "Ubuntu-RG"
}

variable "location" {
    description = "Location for hosting resources"
    default = "North Europe"
}

variable "counter" {
    description = "A possibility to define how many resources will de deployed at once"
    default = 3
}

variable "tags" {
    description = "Mapping of the tags for the resources that are deployed, mandatory"
    type = map(string)
    default = {
      "task" = "Deployment"
    }
}

variable "username" {
  description = "Admin account username"
  default = "azureuser"
}

variable "password" {
  description = "Admin account password"
}

variable "vmsize" {
  description = "Size for the creatable VM"
  default = "Standard_B1s"
}