###############################
## Provision VPC
###############################
resource aws_vpc "this" {
    #IPv4
    cidr_block                              = local.cidr_block
    
    ipv4_ipam_pool_id                       = local.ipv4_ipam_pool_id
    ipv4_netmask_length                     = local.ipv4_netmask_length
    
    #IPv6
    assign_generated_ipv6_cidr_block        = (local.enable_ipv6 && !local.use_ipv6_ipam_pool) ? true : null
    
    ipv6_ipam_pool_id                       = local.ipv6_ipam_pool_id
    ipv6_netmask_length                     = local.ipv6_netmask_length
    ipv6_cidr_block                         = local.ipv6_cidr_block
    
    ipv6_cidr_block_network_border_group    = var.ipv6_cidr_block_network_border_group
    
    instance_tenancy                        = local.instance_tenancy

    #dns
    enable_dns_support                      = local.enable_dns_support
    enable_dns_hostnames                    = local.enable_dns_hostnames

    #classiclink
    enable_classiclink                      = local.enable_classiclink
    enable_classiclink_dns_support          = local.enable_classiclink_dns_support
    
    #Tags
    tags = merge({"Name" = format("%s", local.vpc_name)}, var.default_tags, var.vpc_tags)
}

resource aws_vpc_ipv4_cidr_block_association "this" {
  for_each = var.vpc_secondary_cidr_blocks

    vpc_id = aws_vpc.this.id

    cidr_block          = local.use_ipv4_ipam_pool ? null : each.value.cidr_block
    ipv4_ipam_pool_id   = local.use_ipv4_ipam_pool ? each.value.ipam_pool_id : null
    ipv4_netmask_length = local.use_ipv4_ipam_pool ? each.value.netmask_length : null
  
}

##############################################################
## Provision Internet Gateway and Egress only Internet Gateway
##############################################################
module "igw" {
  source = "./modules/igw"

  count = (var.create_igw || var.create_egress_only_igw) ? 1 : 0

  vpc_id = aws_vpc.this.id

  create_igw = var.create_igw
  create_egress_only_igw = var.create_egress_only_igw
  
  tags = merge({"Name" = format("%s-igw", local.vpc_name)}, var.default_tags, var.igw_tags)
}

###############################
## Provision Subnets of the VPC
###############################

# Public Subnets
module "public_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.public_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)
}

# Private Subnets
module "private_subnets" {
    source = "./modules/subnets"
    
    vpc_id = aws_vpc.this.id
    subnets = local.private_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)
}

# Outpost Subnets
module "outpost_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.outpost_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)
}

###################################################################
## Route Table, uoutes and association to subnets
###################################################################
module "public_route_table" {
    source = "./modules/route-table"

    count = (var.dedicated_public_network_acl && (local.public_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = local.vpc_name

    rt_type = "public"
    subnets = module.public_subnets.subnets_config
    create_igw_ipv4_route = var.create_igw
    igw_id = var.create_igw ? module.igw[0].igw_configs.id : ""
    create_igw_ipv6_route = var.create_egress_only_igw
    egress_igw_id = var.create_egress_only_igw ? module.igw[0].egress_igw_id : ""
}

module "private_route_table" {
    source = "./modules/route-table"

    count = (var.dedicated_private_network_acl && (local.private_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = local.vpc_name

    rt_type = "private"
    subnets = module.private_subnets.subnets_config
}

module "outpost_route_table" {
    source = "./modules/route-table"

    count = (var.dedicated_outpost_network_acl && (local.outpost_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = local.vpc_name

    rt_type = "private"
    subnets = module.outpost_subnets.subnets_config
}

##############################################################
## Network ACLs and Network ACL Rules
##############################################################

# Public Network ACLs and Network ACL Rules
module "public_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_public_network_acl && (local.public_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = local.vpc_name
    
    subnet_id = values(module.public_subnets.subnets_config)[*].id

    acl_type = "public"
    nacl_rules = var.public_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}

# Private Network ACLs and Network ACL Rules
module "private_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_private_network_acl && (local.private_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = local.vpc_name
    
    subnet_id = values(module.private_subnets.subnets_config)[*].id

    acl_type = "private"
    nacl_rules = var.private_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}

# Outpost Network ACLs and Network ACL Rules
module "outpost_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_outpost_network_acl && (local.outpost_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = local.vpc_name
    
    subnet_id = values(module.outpost_subnets.subnets_config)[*].id

    acl_type = "outpost"
    nacl_rules = var.outpost_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}