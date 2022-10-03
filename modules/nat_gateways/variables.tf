variable "vpc_name" {
    description = "The name of the VPC"
    type = string
}

variable "subnets" {
    description = "The subnet details used for NAT Gateways"
    type = map
}

variable "nat_gateways" {
    description = "The configuration map of Nat Gateways"
    type = map
    default = {}
}

variable "tags" {
    description = "(Optional) A map of tags to assign to Route Table."
    type = map
    default = {}
}