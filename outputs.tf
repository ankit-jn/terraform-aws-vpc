## Outputs for VPC
output vpc_config {    
    description = "The VPC Details"
    value = { 
        id                  = aws_vpc.this.id # The ID of VPC
        arn                 = aws_vpc.this.arn # Amazon Resource Name (ARN) of VPC
        owner_id            = aws_vpc.this.owner_id # The ID of the AWS account that owns the VPC.
        cidr_block          = aws_vpc.this.cidr_block # IPv4 CIDR block
        ipv6_cidr_block     = aws_vpc.this.ipv6_cidr_block # IPv6 CIDR block
        instance_tenancy    = aws_vpc.this.instance_tenancy # Tenancy of instances spin up within VPC
    }
}

output "vpc_default_route_table_id" {
    description = "The ID of the route table created by default on VPC creation"
    value = aws_vpc.this.default_route_table_id
}

output "vpc_main_route_table_id" {
    description = "The ID of the main route table associated with this VPC."
    value = aws_vpc.this.main_route_table_id
}

output "vpc_default_network_acl_id" {
    description = "The ID of the network ACL created by default on VPC creation"
    value = aws_vpc.this.default_network_acl_id
}

output "vpc_default_security_group_id" {
    description = "The ID of the security group created by default on VPC creation"
    value = aws_vpc.this.default_security_group_id
}

output "vpc_dhcp_options_id" {
    description = "The ID if DHCP Option"
    value = aws_vpc.this.dhcp_options_id
}

output "vpc_enable_classiclink" {
    description = "Whether or not the VPC has Classiclink enabled"
    value = aws_vpc.this.enable_classiclink
}

output "vpc_enable_classiclink_dns_support" {
    description = "Whether or not the VPC has Classiclink DNS support"
    value = aws_vpc.this.enable_classiclink_dns_support
}

output "vpc_enable_dns_support" {
    description = "Whether or not the VPC has DNS support"
    value = aws_vpc.this.enable_dns_hostnames
}

output "vpc_enable_dns_hostnames" {
    description = "Whether or not the VPC has DNS hostname support"
    value = aws_vpc.this.enable_dns_hostnames
}

output "vpc_ipv6_association_id" {
    description = "The association ID for the IPv6 CIDR block."
    value = aws_vpc.this.ipv6_association_id
}

output "vpc_ipv6_cidr_block_network_border_group" {
    description = "The Network Border Group Zone name"
    value = aws_vpc.this.ipv6_cidr_block_network_border_group
}

output "vpc_tags_all" {
    description = ""
    value = aws_vpc.this.tags_all
}

## Outputs for Internet Gateways
output "vpc_igw" {
    description = "The details of the Internet Gateway."
    value = var.create_igw ? module.igw[0].igw : null
}

output "vpc_egress_igw_id" {
    description = "The ID of the egress-only Internet gateway."
    value = var.create_egress_only_igw ? module.igw[0].egress_igw_id : null
}

# Outputs for Subnets
output "public_subnets" {
    description = "The configuration of All public subnets"
    value = module.public_subnets.subnets_config
}

output "private_subnets" {
    description = "The configuration of All public subnets"
    value = module.private_subnets.subnets_config
}

output "outpost_subnets" {
    description = "The configuration of All public subnets"
    value = module.outpost_subnets.subnets_config
}