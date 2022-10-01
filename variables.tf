variable "vpc_base_configs" {
    description = <<EOF
(Optional) Basic configuration Map for VPC with the following entries:

vpc_name - (Optional) The name of the VPC; Default value - ""
use_ipv4_ipam_pool - (Optional) Set flag true if use ipam pool for IPv4 CIDRs; Default value - false
enable_ipv6 - (Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC; Default value - false
use_ipv6_ipam_pool - (Optional) Set flag true if use ipam pool for IPv6 CIDRs; Default value - false
instance_tenancy - (Optional) A tenancy option for instances launched into the VPC; Defaule value - "default"
enable_dhcp_options - (Optional) Set it to true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type; Default value - false
EOF
    type = map
    default = {}
}

variable "vpc_ipv4_configs" {
    description = <<EOF
(Required) Reference Values for IPv4 CIDR:"

Note - 
Either set the value of property [ipv4_cidr_block] to explicitely set CIDR block for VPC  
or Set the ipam specific properties [ipam_pool_id and netmask_length] for deriving CIDR from IPAM 

cidr_block - (Optional) The IPv4 CIDR block for the VPC.

ipam_pool_id - (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR.
netmask_length - (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC.

EOF
    type = map
}

variable "vpc_ipv6_configs" {
    description = <<EOF
(Optional) Reference Values for IPv6 CIDR requested from IPAM: 
[Required only if vpc_base_configs.enable_ipv6 is set tru]

ipam_pool_id - IPAM Pool ID for a IPv6 pool.

cidr_block - (Optional) IPv6 CIDR block to request from an IPAM Pool.
netmask_length - (Optional) Netmask length to request from IPAM Pool.

Note - 
Either set the value of property [cidr_block] to explicitely set CIDR block for VPC  
or Set the ipam specific property [netmask_length] for deriving CIDR from IPAM 
EOF
    type = map
    default = null
}

variable "ipv6_cidr_block_network_border_group" {
    description = "(Optional) By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC."
    type = number
    default = null
}

variable "vpc_dns_configs" {
    description = <<EOF
(Optional) Reference Values for DNS Support:"
enable_dns_support - (Optional) A boolean flag to enable/disable DNS support in the VPC.
vpc_dns_host_name - (Optional) A boolean flag to enable/disable DNS hostnames in the VPC.
EOF
    type        = map
    default = {
        enable_dns_support = true
        dns_host_name = false
    }
}

variable "vpc_classiclink_configs" {
    description = <<EOF
(Optional) Reference Values for DNS Support:"
enable_classiclink - (Optional) A boolean flag to enable/disable ClassicLink for the VPC.
enable_classiclink_dns_support - (Optional) A boolean flag to enable/disable ClassicLink DNS Support for the VPC.
EOF
    type        = map
    default = {
        enable_classiclink              = false
        enable_classiclink_dns_support  = false
    }
}

variable "vpc_secondary_cidr_blocks" {
  description = <<EOF
Map of Secondary CIDR blocks configurations where 
Map Key - Any unique identifire
Map Value - It will again be a map of CIDR configurations witht the following properties:

cidr_block - (Optional) The IPv4 CIDR block for the VPC.
ipam_pool_id - (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR.
netmask_length - (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC.

Sample
"CIDR-1" = {
    cidr_block - "x.x.x.x/xx"
},
"CIDR-2 = {
    ipam_pool_id - "ipam-xxxx"
    netmask_length - 28
}
EOF
  type        = map
  default     = {}

}

variable "vpc_tags" {
    description = "(Optional) A map of tags to assign to the resource."
    type = map
    default = {}
}

####################################
## DHCP Options Specific Variables 
####################################
variable "dhcp_options_domain_name" {
    description = <<EOF
(Optional) the suffix domain name to use by default when resolving non Fully Qualified Domain Names.
This will require enable_dhcp_options set to true
EOF
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = <<EOF
(Optional) List of name servers to configure in /etc/resolv.conf.
This will require enable_dhcp_options set to true
EOF
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = <<EOF
(Optional) List of NTP servers to configure.
This will require enable_dhcp_options set to true
EOF
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = <<EOF
(Optional) List of NETBIOS name servers.
This will require enable_dhcp_options set to true
EOF
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = <<EOF
(Optional) The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 
since broadcast and multicast are not supported in their network.
This will require enable_dhcp_options set to true
EOF
  type        = string
  default     = ""
}

#########################################
## Default NACL
#########################################
variable "default_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}

variable "default_route_table_routes" {
  description = <<EOF
List of Routes where each value of the list will be a map with the following Keys:

route_key - This must be a uniue identifiier of this list of map

# One of the following key is mandatory
cidr_block - (Required) The CIDR block of the route.
ipv6_cidr_block - (Optional) The Ipv6 CIDR block of the route

One of the following keys is mandatory
core_network_arn - (Optional) The Amazon Resource Name (ARN) of a core network.
egress_only_gateway_id - (Optional) Identifier of a VPC Egress Only Internet Gateway.
gateway_id - (Optional) Identifier of a VPC internet gateway or a virtual private gateway.
instance_id - (Optional) Identifier of an EC2 instance.
nat_gateway_id - (Optional) Identifier of a VPC NAT gateway.
network_interface_id - (Optional) Identifier of an EC2 network interface.
transit_gateway_id - (Optional) Identifier of an EC2 Transit Gateway.
vpc_endpoint_id - (Optional) Identifier of a VPC Endpoint.
vpc_peering_connection_id - (Optional) Identifier of a VPC peering connection.

Sample: 
[
  {
    route_key="rt-1"
    cidr_block = "x.x.x.x/xx"
    instance_id = "i-xxxxxx"
  },
  {
    route_key="rt-2"
    cidr_block = "y.y.y.y/yy"
    network_interface_id = "nic-xxxxx"
  }
]
EOF
  type        = list(map(string))
  default     = []
}
#########################################
## Default Route table
#########################################
variable "default_network_acl" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = map

  default = {
    "ingress" =  [
      {
        rule_no    = 100
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      },
      {
        rule_no         = 101
        action          = "allow"
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        ipv6_cidr_block = "::/0"
      },
    ],
    "egress" = [
      {
        rule_no    = 100
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      },
      {
        rule_no         = 101
        action          = "allow"
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        ipv6_cidr_block = "::/0"
      },
    ]
  }
}

#########################################
## Default Security Group Specific Rules
#########################################
variable "default_sg_rules" {
    description = <<EOF
(Optional) Reference Values for Security Group Rules of Default Security Group:"
It is a map of Rule Pairs where,
Key of the map is Rule Type and Value of the map would be an array of Security Rules Map 
There could be 3 Rule Types [Keys] : 'ingress-cidr', 'ingress-self', 'egress'

Sample:

ingress-cidr = [
    {
        rule_name = "<Name of the rule>"
        from_port = <Value of from Port>
        to_port = <Value of to Port>
        protocol = "<Protocol>"
        cidr_blocks = ["<CIDR Block>"] 
    }
],
ingress-self = [
    {
        rule_name = "<Name of the rule>"
        from_port = <Value of from Port>
        to_port = <Value of to Port>
        protocol = "<Protocol>"
    }
],
egress = [
    {
        rule_name = "<Name of the rule>"
        from_port = <Value of from Port>
        to_port = <Value of to Port>
        protocol = "<Protocol>"
        cidr_blocks = ["<CIDR Block>"] 
    }
]

EOF
    default = []
}

####################################################
## Internet Gateway and Egress Only Internet Gateway
####################################################
variable "create_igw" {
    description = "(Optional) The VPC ID to create in."
    type = bool
    default = true
}

variable "create_egress_only_igw" {
    description = "(Optional) The VPC ID to create in."
    type = bool
    default = false
}

variable "igw_tags" {
    description = "(Optional) A map of tags to assign to the resource."
    type = map
    default = {}
}