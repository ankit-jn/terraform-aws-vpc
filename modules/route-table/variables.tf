variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
}

variable "vpc_name" {
    description = "The name of the VPC"
    type = string
}

variable "rt_type" {
    description = ""
    type = string
    default = ""
}

variable "subnets" {
    description = "The subnet details used for Route table associations"
    type = map
}

variable "create_igw_ipv4_route" {
    description = "value"
    type = bool
    default = false
}

variable "igw_id" {
    description = "value"
    type = string
    default = ""
}

variable "create_igw_ipv6_route" {
    description = "value"
    type = bool
    default = false
}

variable "egress_igw_id" {
    description = "value"
    type = string
    default = ""
}

variable "create_nat_gateway_routes" {
    description = "value"
    type = bool
    default = false
}

variable "nat_gateway_id" {
    description = "The ID of the NAT Gateway"
    type = string
    default = null
}

variable "tags" {
    description = "(Optional) A map of tags to assign to Route Table."
    type = map
    default = {}
}
