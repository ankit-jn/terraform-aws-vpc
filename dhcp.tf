################################################################
## DHCP Options Set
################################################################

resource aws_vpc_dhcp_options "this" {
    count = local.enable_dhcp_options ? 1 : 0

    domain_name          = var.dhcp_options_domain_name
    domain_name_servers  = var.dhcp_options_domain_name_servers
    ntp_servers          = var.dhcp_options_ntp_servers
    netbios_name_servers = var.dhcp_options_netbios_name_servers
    netbios_node_type    = var.dhcp_options_netbios_node_type

    tags = merge({"Name" = format("%s", local.vpc_name)}, var.vpc_tags)
}

resource aws_vpc_dhcp_options_association "this" {
    count = local.enable_dhcp_options ? 1 : 0

    vpc_id          = aws_vpc.this.id
    dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}