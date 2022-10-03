###################################################################
## Public route Table, Routes and Association to Public Subnets
###################################################################
resource aws_route_table "public" {
    count = local.public_subnets_count > 0 ? 1 : 0

    vpc_id = aws_vpc.this.id

    tags = merge(
        {"Name" = format("%s-rt-public", local.vpc_name)}, 
        var.default_tags, 
        var.rt_default_tags
    )
}

resource aws_route "igw_ipv4_route" {
  count = (var.create_igw && local.public_subnets_count > 0) ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.igw[0].igw_configs.id

  timeouts {
    create = "5m"
  }
}

resource aws_route "igw_ipv6_route" {
  count = (var.create_egress_only_igw && local.public_subnets_count > 0) ? 1 : 0

  route_table_id                = aws_route_table.public[0].id
  destination_ipv6_cidr_block   = "::/0"
  gateway_id                    = module.igw[0].egress_igw_id

  timeouts {
    create = "5m"
  }
}

resource aws_route_table_association "public" {
  for_each = module.public_subnets.subnets_config

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

###################################################################
## Private route Table, Routes and Association to private Subnets
###################################################################
resource aws_route_table "private" {
    count = local.private_subnets_count > 0 ? 1 : 0

    vpc_id = aws_vpc.this.id

    tags = merge(
        {"Name" = format("%s-rt-private", local.vpc_name)}, 
        var.default_tags, 
        var.rt_default_tags
    )
}

resource aws_route_table_association "private" {
  for_each = module.private_subnets.subnets_config

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}

###################################################################
## Outpost subnets association with private route Table 
###################################################################
resource aws_route_table_association "outpost" {
  for_each = module.outpost_subnets.subnets_config

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}

###################################################################
## Default route Table
###################################################################

resource aws_default_route_table "default" {
  
    default_route_table_id = aws_vpc.this.default_route_table_id
    propagating_vgws       = var.default_route_table_propagating_vgws

    # route = []

    dynamic "route" {
        for_each = { for route in flatten(var.default_route_table_routes) : route.route_key => route }
        content {
            # Destination - One of the following must be configured
            cidr_block      = route.value.cidr_block
            ipv6_cidr_block = lookup(route.value, "ipv6_cidr_block", null)

            # Target - One of the following must be configured
            core_network_arn          = lookup(route.value, "core_network_arn", null)
            egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
            gateway_id                = lookup(route.value, "gateway_id", null)
            instance_id               = lookup(route.value, "instance_id", null)
            nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
            network_interface_id      = lookup(route.value, "network_interface_id", null)
            transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
            vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
            vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
        }
    }

    timeouts {
        create = "5m"
        update = "5m"
    }

    tags = merge(
        {"Name" = format("%s-rt-default", local.vpc_name)}, 
        var.default_tags, 
        var.rt_default_tags
    )
}