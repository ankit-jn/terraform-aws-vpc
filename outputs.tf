## Outputs for VPC
output vpc_config {    
    description = "The VPC Details"
    value = try(module.vpc[0].vpc_config, {})
}

output "vpc_default_route_table_id" {
    description = "The ID of the route table created by default on VPC creation"
    value = try(module.vpc[0].vpc_default_route_table_id, "")
}

output "vpc_main_route_table_id" {
    description = "The ID of the main route table associated with this VPC."
    value = try(module.vpc[0].vpc_main_route_table_id, "")
}

output "vpc_default_network_acl_id" {
    description = "The ID of the network ACL created by default on VPC creation"
    value = try(module.vpc[0].vpc_default_network_acl_id, "")
}

output "vpc_default_security_group_id" {
    description = "The ID of the security group created by default on VPC creation"
    value = try(module.vpc[0].vpc_default_security_group_id, "")
}

output "vpc_dhcp_options_id" {
    description = "The ID if DHCP Option"
    value = try(module.vpc[0].vpc_dhcp_options_id, null)
}

output "vpc_enable_classiclink" {
    description = "Whether or not the VPC has Classiclink enabled"
    value = try(module.vpc[0].vpc_enable_classiclink, false)
}

output "vpc_enable_classiclink_dns_support" {
    description = "Whether or not the VPC has Classiclink DNS support"
    value = try(module.vpc[0].vpc_enable_classiclink_dns_support, false)
}

output "vpc_enable_dns_support" {
    description = "Whether or not the VPC has DNS support"
    value = try(module.vpc[0].vpc_enable_dns_hostnames, true)
}

output "vpc_enable_dns_hostnames" {
    description = "Whether or not the VPC has DNS hostname support"
    value = try(module.vpc[0].vpc_enable_dns_hostnames, false)
}

output "vpc_ipv6_association_id" {
    description = "The association ID for the IPv6 CIDR block."
    value = try(module.vpc[0].vpc_ipv6_association_id, "")
}

output "vpc_ipv6_cidr_block_network_border_group" {
    description = "The Network Border Group Zone name"
    value = try(module.vpc[0].vpc_ipv6_cidr_block_network_border_group, null)
}

output "vpc_tags_all" {
    description = "All tags associated to VPC"
    value = try(module.vpc[0].vpc_tags_all, {})
}

## Outputs for Internet Gateways
output "vpc_igw" {
    description = "The details of the Internet Gateway."
    value = try(module.igw[0].igw_configs, "")
}

output "vpc_egress_igw_id" {
    description = "The ID of the egress-only Internet gateway."
    value = try(module.igw[0].egress_igw_id, "")
}

# Outputs for Subnets
output "subnets" {
    description = "The configuration of all subnets"
    value = module.subnets.subnets_config
}

# Outputs for Route Tables
output "route_table_id" {
    description = "ID of route table"
    value       = try(module.route_table[0].route_table_id, "")
}

output nat_gatways_config {    
    description = "The Nat gateway Details"
    value = module.nat_gateways.nat_gatways_config
}