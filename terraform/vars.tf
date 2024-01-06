variable "prefix" {
  description = "User can define a suitable prefix for certain resources"
  default     = "Udacity"
}

variable "location" {
  description = "Location for hosting resources"
  default     = "North Europe"
}

variable "counter" {
  description = "A possibility to define how many resources will de deployed at once"
  default     = 3
}

variable "tags" {
  description = "Mapping of the tags for the resources that are deployed, mandatory"
  type        = map(string)
  default = {
    "task" = "Deployment"
  }
}

variable "username" {
  description = "Admin account username"
  default     = "azureuser"
}

variable "password" {
  description = "Admin account password"
}

variable "vmsize" {
  description = "Size for the creatable VM"
  default     = "Standard_B1s"
}

variable "disk_size" {
  description = "Managed disk size gigabytes"
  default     = 5
}

variable "packer_resource_group" {
  description = "Name of the resource group in which the Packer image was created"
  default     = "Ubuntu-RG"
}

variable "packer_image_name" {
  description = "Name of the Packer image"
  default     = "ubuntuImage"
}