variable "vpc_id" {
    description = "(Required) The VPC ID to create in."
    type = string
}

variable "create_igw" {
    description = "(Required) The VPC ID to create in."
    type = bool
    default = true
}

variable "create_egress_only_igw" {
    description = "(Required) The VPC ID to create in."
    type = bool
    default = false
}

variable "igw_tags" {
    description = "(Optional) A map of tags to assign to the resource."
    type = map
    default = {}
}