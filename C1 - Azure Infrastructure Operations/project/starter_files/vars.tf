variable "prefix" {
    description = "User can define a suitable prefix for certain resources"
    default = "Ubuntu"
}

variable "location" {
    description = "Location for hosting resources"
    default = "North Europe"
}

variable "count" {
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