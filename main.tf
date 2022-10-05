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

##############################################################
## Provision Internet Gateway and Egress only Internet Gateway
##############################################################
module "igw" {
  source = "./modules/igw"

  count = (var.create_igw || var.create_egress_only_igw) ? 1 : 0

  vpc_id = aws_vpc.this.id
  vpc_name = var.vpc_name

  create_igw = var.create_igw
  create_egress_only_igw = var.create_egress_only_igw
  
  tags = merge(var.default_tags, var.igw_tags)
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

    depends_on = [
        aws_vpc.this,
        aws_vpc_ipv4_cidr_block_association.this
    ]
}

# Infrastructure Subnets
module "infra_subnets" {
    source = "./modules/subnets"
    
    vpc_id = aws_vpc.this.id
    subnets = local.infra_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)

    depends_on = [
        aws_vpc.this,
        aws_vpc_ipv4_cidr_block_association.this
    ]
}

# Outpost Subnets
module "outpost_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.outpost_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)

    depends_on = [
        aws_vpc.this,
        aws_vpc_ipv4_cidr_block_association.this
    ]
}

# application Subnets
module "application_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.application_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)

    depends_on = [
        aws_vpc.this,
        aws_vpc_ipv4_cidr_block_association.this
    ]
}

# db Subnets
module "db_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.db_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)

    depends_on = [
        aws_vpc.this,
        aws_vpc_ipv4_cidr_block_association.this
    ]
}
###################################################################
## Nat Gateway
###################################################################
module "nat_gateways" {
    source = "./modules/nat_gateways"

    vpc_name = var.vpc_name
    nat_gateways = var.nat_gateways
    subnets = module.infra_subnets.subnets_config
    tags = merge(var.default_tags, var.nat_gateway_tags)
}

###################################################################
## Route Table, uoutes and association to subnets
###################################################################
module "public_route_table" {
    source = "./modules/route_table"

    count = (local.public_subnets_count > 0) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name

    rt_type = "public"
    subnets = module.public_subnets.subnets_config

    create_igw_ipv4_route = var.create_igw
    igw_id = var.create_igw ? module.igw[0].igw_configs.id : ""
    create_igw_ipv6_route = var.create_egress_only_igw
    egress_igw_id = var.create_egress_only_igw ? module.igw[0].egress_igw_id : ""
}

module "infra_route_table" {
    source = "./modules/route_table"

    count = (local.infra_subnets_count > 0) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name

    rt_type = "infra"
    subnets = module.infra_subnets.subnets_config

    create_igw_ipv4_route = var.create_igw
    igw_id = var.create_igw ? module.igw[0].igw_configs.id : ""
    create_igw_ipv6_route = var.create_egress_only_igw
    egress_igw_id = var.create_egress_only_igw ? module.igw[0].egress_igw_id : ""
}

module "outpost_route_table" {
    source = "./modules/route_table"

    count = (local.outpost_subnets_count > 0) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name

    rt_type = "infra"
    subnets = module.outpost_subnets.subnets_config

    create_nat_gateway_routes = local.enable_nat_gateway
    nat_gateway_id = local.single_nat_gateway ? local.nat_gateway_ids[0] : local.nat_gateways_for_outpost_subnets
}

module "application_route_table" {
    source = "./modules/route_table"

    count = (local.application_subnets_count > 0) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name

    rt_type = "application"
    subnets = module.application_subnets.subnets_config

    create_nat_gateway_routes = local.enable_nat_gateway
    nat_gateway_id = local.single_nat_gateway ? local.nat_gateway_ids[0] : local.nat_gateways_for_application_subnets
}

module "db_route_table" {
    source = "./modules/route_table"

    count = (local.db_subnets_count > 0) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name

    rt_type = "database"
    subnets = module.db_subnets.subnets_config

    create_nat_gateway_routes = local.enable_nat_gateway
    nat_gateway_id = local.single_nat_gateway ? local.nat_gateway_ids[0] : local.nat_gateways_for_db_subnets
}

##############################################################
## Network ACLs and Network ACL Rules
##############################################################

# Public Network ACLs and Network ACL Rules
module "public_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_public_network_acl && (local.public_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name
    
    subnet_id = values(module.public_subnets.subnets_config)[*].id

    acl_type = "public"
    nacl_rules = var.public_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}

# Infrastructure Network ACLs and Network ACL Rules
module "infra_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_infra_network_acl && (local.infra_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name
    
    subnet_id = values(module.infra_subnets.subnets_config)[*].id

    acl_type = "infra"
    nacl_rules = var.infra_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}

# Outpost Network ACLs and Network ACL Rules
module "outpost_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_outpost_network_acl && (local.outpost_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name
    
    subnet_id = values(module.outpost_subnets.subnets_config)[*].id

    acl_type = "outpost"
    nacl_rules = var.outpost_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}

# Application Network ACLs and Network ACL Rules
module "application_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_application_network_acl && (local.application_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name
    
    subnet_id = values(module.application_subnets.subnets_config)[*].id

    acl_type = "application"
    nacl_rules = var.application_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}

# Database Network ACLs and Network ACL Rules
module "db_network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_db_network_acl && (local.db_subnets_count > 0)) ? 1 : 0

    vpc_id = aws_vpc.this.id
    vpc_name = var.vpc_name
    
    subnet_id = values(module.db_subnets.subnets_config)[*].id

    acl_type = "database"
    nacl_rules = var.db_nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}