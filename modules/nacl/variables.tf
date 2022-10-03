variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
}

variable "vpc_name" {
    description = "The name of the VPC"
    type = string
}

variable "acl_type" {
    description = "The Type of the NACL: public, private, outpost"
    type = string
    default = ""
}

variable "subnet_id" {
    description = "A list of Subnet IDs to apply the Network ACL to"
    type = list(string)
}

variable "nacl_rules" {
    description = <<EOF
(Optional) Reference Values for Rules for Dedicated Network ACL:"
It is a map of Rule Pairs where,
Key of the map is Rule Type and Value of the map would be an array of Rules Map 
There could be 2 Rule Types [Keys] : 'inbound', 'outbound'
EOF
    type = map
}

variable "tags" {
    description = "(Optional) A map of tags to assign to the Network ACL."
    type = map
    default = {}
}

