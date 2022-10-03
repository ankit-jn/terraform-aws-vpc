locals {
    instance_tenancy = lookup(var.vpc_base_configs, "instance_tenancy", "default")
    enable_dhcp_options = lookup(var.vpc_base_configs, "enable_dhcp_options", false)
    vpc_name = lookup(var.vpc_base_configs, "vpc_name", "")
    
    #IPv4
    use_ipv4_ipam_pool      = lookup(var.vpc_base_configs, "use_ipv4_ipam_pool", false)
    cidr_block              = (!local.use_ipv4_ipam_pool) ? var.vpc_ipv4_configs.cidr_block : null
    ipv4_ipam_pool_id       = local.use_ipv4_ipam_pool ? var.vpc_ipv4_configs.ipam_pool_id : null
    ipv4_netmask_length     = local.use_ipv4_ipam_pool ? var.vpc_ipv4_configs.netmask_length : null
    
    #IPv6
    enable_ipv6 = lookup(var.vpc_base_configs, "enable_ipv6", false)
    use_ipv6_ipam_pool  = lookup(var.vpc_base_configs, "use_ipv6_ipam_pool", false)
    derive_ipv6 =  (local.enable_ipv6 && local.use_ipv6_ipam_pool) ? true : false
    
    ipv6_ipam_pool_id       = local.derive_ipv6 ? var.vpc_ipv6_configs.ipam_pool_id : null
    specific_ipv6_cidr      = (local.derive_ipv6 && can(var.vpc_ipv6_configs.cidr_block)) ? true : false
    ipv6_cidr_block         = (local.derive_ipv6 && local.specific_ipv6_cidr) ? var.vpc_ipv6_configs.cidr_block : null
    ipv6_netmask_length     = (local.derive_ipv6 && !local.specific_ipv6_cidr) ? var.vpc_ipv6_configs.netmask_length : null
 
    #dns
    enable_dns_support      = can(var.vpc_dns_configs.enable_dns_support) ? var.vpc_dns_configs.enable_dns_support : true
    enable_dns_hostnames    = can(var.vpc_dns_configs.enable_dns_hostnames) ? var.vpc_dns_configs.enable_dns_hostnames : false
   
    #classiclink
    enable_classiclink              = can(var.vpc_classiclink_configs.enable_classiclink) ? var.vpc_classiclink_configs.enable_classiclink : false
    enable_classiclink_dns_support  = can(var.vpc_classiclink_configs.enable_classiclink_dns_support) ? var.vpc_classiclink_configs.enable_classiclink_dns_support : false

    #Default NACL Rules
    default_nacl_ingress_rules = { for k, v in var.default_network_acl : k => v if k == "ingress" }
    default_nacl_egress_rules = { for k, v in var.default_network_acl : k => v if k == "egress" }
    
    #Default Security Group Rules
    default_sg_ingress_cidr_rules = { for k, v in var.default_sg_rules : k => v if k == "ingress-cidr" }
    default_sg_ingress_self_rules = { for k, v in var.default_sg_rules : k => v if k == "ingress-self" }
    default_sg_egress_rules = { for k, v in var.default_sg_rules : k => v if k == "egress" }

    vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this.id, "")

    #VPC Subnets
    public_subnets = flatten([for subnets_type, value in var.subnets : value if subnets_type == "public-subnets" ])
    private_subnets = flatten([for subnets_type, value in var.subnets : value if subnets_type == "private-subnets" ])
    outpost_subnets = flatten([for subnets_type, value in var.subnets : value if subnets_type == "outpost-subnets" ])
    application_subnets = flatten([for subnets_type, value in var.subnets : value if subnets_type == "application-subnets" ])
    db_subnets = flatten([for subnets_type, value in var.subnets : value if subnets_type == "db-subnets" ])
    
    public_subnets_count = length(local.public_subnets)
    private_subnets_count = length(local.private_subnets)
    outpost_subnets_count = length(local.outpost_subnets)
    application_subnets_count = length(local.application_subnets)
    db_subnets_count = length(local.db_subnets)


    ## NAT Gateway and ROutes association specific variables
    enable_nat_gateway = length(keys(var.nat_gateways)) > 0
    single_nat_gateway = length(keys(var.nat_gateways)) == 1
    multiple_nat_gateways = length(keys(var.nat_gateways)) > 1

    nat_gateway_ids = local.enable_nat_gateway ? values(module.nat_gateways.nat_gatways_config)[*].id : []

    nat_gateways_for_private_subnets = local.multiple_nat_gateways && can(var.nat_gateway_routes["private-subnets"]) ? (module.nat_gateways.nat_gatways_config[var.nat_gateway_routes["private-subnets"]].id) : local.nat_gateway_ids[0]
    nat_gateways_for_outpost_subnets = local.multiple_nat_gateways && can(var.nat_gateway_routes["outpost-subnets"]) ? (module.nat_gateways.nat_gatways_config[var.nat_gateway_routes["outpost-subnets"]].id) : local.nat_gateway_ids[0]
    nat_gateways_for_application_subnets = local.multiple_nat_gateways && can(var.nat_gateway_routes["application-subnets"]) ? (module.nat_gateways.nat_gatways_config[var.nat_gateway_routes["application-subnets"]].id) : local.nat_gateway_ids[0]
    nat_gateways_for_db_subnets = local.multiple_nat_gateways && can(var.nat_gateway_routes["db-subnets"]) ? (module.nat_gateways.nat_gatways_config[var.nat_gateway_routes["db-subnets"]].id) : local.nat_gateway_ids[0]
}