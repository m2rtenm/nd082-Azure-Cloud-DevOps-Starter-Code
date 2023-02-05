variable "prefix" {
    description = "User can define a suitable prefix for certain resources"
    default = "Nanodegree"
}

variable "location" {
    description = "Location for hosting resources"
    default = "North Europe"
}

variable "count" {
    description = "A possibility to define how many resources will de deployed at once"
    default = 3
}