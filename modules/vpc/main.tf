###############################
## Provision VPC
###############################
resource aws_vpc "this" {
    #IPv4
    cidr_block                              = local.ipv4_cidr_block
    
    ipv4_ipam_pool_id                       = local.ipv4_ipam_pool_id
    ipv4_netmask_length                     = local.ipv4_netmask_length
    
    #IPv6
    assign_generated_ipv6_cidr_block        = (var.enable_ipv6 && !local.use_ipv6_ipam_pool) ? true : null
    
    ipv6_ipam_pool_id                       = local.ipv6_ipam_pool_id
    ipv6_netmask_length                     = local.ipv6_netmask_length
    ipv6_cidr_block                         = local.ipv6_cidr_block
    
    ipv6_cidr_block_network_border_group    = local.ipv6_cidr_block_network_border_group
    
    instance_tenancy                        = local.instance_tenancy

    #dns
    enable_dns_support                      = local.enable_dns_support
    enable_dns_hostnames                    = local.enable_dns_hostnames

    #classiclink
    enable_classiclink                      = local.enable_classiclink
    enable_classiclink_dns_support          = local.enable_classiclink_dns_support
    
    #Tags
    tags = merge({"Name" = format("%s", var.vpc_name)}, var.default_tags, var.vpc_tags)
}

resource aws_vpc_ipv4_cidr_block_association "this" {
  for_each = var.vpc_secondary_cidr_blocks

    vpc_id = aws_vpc.this.id

    cidr_block          = local.use_ipv4_ipam_pool ? null : each.value.cidr_block
    ipv4_ipam_pool_id   = local.use_ipv4_ipam_pool ? each.value.ipam_pool_id : null
    ipv4_netmask_length = local.use_ipv4_ipam_pool ? each.value.netmask_length : null
  
}
