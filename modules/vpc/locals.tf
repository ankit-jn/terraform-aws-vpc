locals {

    instance_tenancy = lookup(var.vpc_base_configs, "instance_tenancy", "default")
    enable_dhcp_options = lookup(var.vpc_base_configs, "enable_dhcp_options", false)
    ipv6_cidr_block_network_border_group = lookup(var.vpc_base_configs, "ipv6_cidr_block_network_border_group", null)
    
    #IPv4
    use_ipv4_ipam_pool      = lookup(var.vpc_ipam_configs, "use_ipv4_ipam_pool", false)
    ipv4_cidr_block         = (!local.use_ipv4_ipam_pool) ? var.ipv4_cidr_block : null
    ipv4_ipam_pool_id       = local.use_ipv4_ipam_pool ? var.vpc_ipam_configs.ipv4_ipam_pool_id : null
    ipv4_netmask_length     = local.use_ipv4_ipam_pool ? var.vpc_ipam_configs.ipv4_netmask_length : null
    
    #IPv6
    use_ipv6_ipam_pool  = lookup(var.vpc_ipam_configs, "use_ipv6_ipam_pool", false)
    derive_ipv6 =  (var.enable_ipv6 && local.use_ipv6_ipam_pool) ? true : false
    
    ipv6_ipam_pool_id       = local.derive_ipv6 ? var.vpc_ipam_configs.ipv6_ipam_pool_id : null
    specific_ipv6_cidr      = (local.derive_ipv6 && can(var.ipv6_cidr_block)) ? true : false
    ipv6_cidr_block         = (local.derive_ipv6 && local.specific_ipv6_cidr) ? var.ipv6_cidr_block : null
    ipv6_netmask_length     = (local.derive_ipv6 && !local.specific_ipv6_cidr) ? var.vpc_ipam_configs.ipv6_netmask_length : null
 
    #dns
    enable_dns_support      = can(var.vpc_dns_configs.enable_dns_support) ? var.vpc_dns_configs.enable_dns_support : true
    enable_dns_hostnames    = can(var.vpc_dns_configs.enable_dns_hostnames) ? var.vpc_dns_configs.enable_dns_hostnames : false
   
    #classiclink
    enable_classiclink              = can(var.vpc_classiclink_configs.enable_classiclink) ? var.vpc_classiclink_configs.enable_classiclink : false
    enable_classiclink_dns_support  = can(var.vpc_classiclink_configs.enable_classiclink_dns_support) ? var.vpc_classiclink_configs.enable_classiclink_dns_support : false

    #Default NACL Rules
    default_nacl_inbound_rules = { for k, v in var.default_network_acl : k => v if k == "inbound" }
    default_nacl_outbound_rules = { for k, v in var.default_network_acl : k => v if k == "outbound" }
    
    #Default Security Group Rules
    default_sg_ingress_cidr_rules = { for k, v in var.default_sg_rules : k => v if k == "ingress-cidr" }
    default_sg_ingress_self_rules = { for k, v in var.default_sg_rules : k => v if k == "ingress-self" }
    default_sg_egress_rules = { for k, v in var.default_sg_rules : k => v if k == "egress" }

}