###############################
## Retrieve VPC details
###############################
module "vpc" {
  source = "./modules/vpc"

  count = var.create_vpc ? 1 : 0

  vpc_name          = var.vpc_name
  ipv4_cidr_block   = var.ipv4_cidr_block
  enable_ipv6       = var.enable_ipv6
  ipv6_cidr_block   = var.ipv6_cidr_block

  vpc_base_configs          = var.vpc_base_configs
  vpc_ipam_configs          = var.vpc_ipam_configs
  vpc_dns_configs           = var.vpc_dns_configs
  vpc_classiclink_configs   = var.vpc_classiclink_configs
  
  vpc_secondary_cidr_blocks = var.vpc_secondary_cidr_blocks
  
  dhcp_options_domain_name          = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers  = var.dhcp_options_domain_name_servers
  dhcp_options_ntp_servers          = var.dhcp_options_ntp_servers
  dhcp_options_netbios_name_servers = var.dhcp_options_netbios_name_servers
  dhcp_options_netbios_node_type    = var.dhcp_options_netbios_node_type
  
  default_route_table_propagating_vgws  = var.default_route_table_propagating_vgws
  default_route_table_routes            = var.default_route_table_routes
  default_network_acl                   = var.default_network_acl
  default_sg_rules                      = var.default_sg_rules

  default_tags      = var.default_tags
  vpc_tags          = var.vpc_tags
  rt_default_tags   = var.rt_default_tags
  
}

##############################################################
## Provision Internet Gateway and Egress only Internet Gateway
##############################################################
module "igw" {
  source = "./modules/igw"

  count = var.create_vpc && (var.create_igw || var.create_egress_only_igw) ? 1 : 0

  vpc_id = local.vpc_id
  vpc_name = var.vpc_name

  create_igw = var.create_igw
  create_egress_only_igw = var.create_egress_only_igw
  
  tags = merge(var.default_tags, var.igw_tags)
}

###############################
## Provision Subnets of the VPC
###############################

module "subnets" {
    source = "./modules/subnets"

    vpc_id = local.vpc_id
    
    subnets = var.subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)

    depends_on = [
        module.vpc
    ]
}

###################################################################
## Nat Gateway
###################################################################
module "nat_gateways" {
    source = "./modules/nat_gateways"

    vpc_name = var.vpc_name
    nat_gateways = var.nat_gateways
    subnets = module.subnets.subnets_config
    tags = merge(var.default_tags, var.nat_gateway_tags)
}

###################################################################
## Route Table, uoutes and association to subnets
###################################################################
module "route_table" {
    source = "./modules/route_table"

    count = var.dedicated_route_table && (local.subnets_count > 0) ? 1 : 0

    vpc_id = local.vpc_id
    vpc_name = var.vpc_name

    rt_type = var.subnets_type
    subnets = module.subnets.subnets_config

    create_igw_ipv4_route = local.create_igw_ipv4_route
    igw_id = local.igw_id
    
    create_igw_ipv6_route = local.create_igw_ipv6_route
    egress_igw_id = local.egress_igw_id

    create_nat_gateway_routes = var.create_nat_gateway_route
    nat_gateway_id = var.nat_gateway_id
}

##############################################################
## Network ACLs and Network ACL Rules
##############################################################

module "network_acl" {
    source = "./modules/nacl"

    count = (var.dedicated_network_acl && (local.subnets_count > 0)) ? 1 : 0

    vpc_id = local.vpc_id
    vpc_name = var.vpc_name
    
    subnet_id = values(module.subnets.subnets_config)[*].id

    acl_type = var.subnets_type
    nacl_rules = var.nacl_rules
    tags = merge(var.default_tags, var.network_acl_default_tags)
}