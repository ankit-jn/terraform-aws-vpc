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

    tags = merge({"Name" = format("%s", local.vpc_name)}, var.vpc_tags)
}