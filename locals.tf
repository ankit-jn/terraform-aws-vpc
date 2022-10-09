locals {
    vpc_id = var.create_vpc ? module.vpc[0].vpc_config.id : data.aws_vpc.this[0].id
    subnets_count = length(var.subnets)

    create_igw_ipv4_route = (var.create_igw && var.create_igw_ipv4_route) ? true : false
    create_igw_ipv6_route = (var.create_egress_only_igw && var.create_igw_ipv6_route) ? true : false
    igw_id = (var.create_vpc && var.create_igw) ? module.igw[0].igw_configs.id : local.create_igw_ipv4_route ? data.aws_internet_gateway.this[0].id : ""
    egress_igw_id = (var.create_vpc && var.create_egress_only_igw) ? module.igw[0].egress_igw_id : var.egress_igw_id

}