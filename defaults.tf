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

################################################################
## Default Network ACLs
################################################################

resource aws_default_network_acl "this" {

  default_network_acl_id = aws_vpc.this.default_network_acl_id

  subnet_ids = null

  dynamic "ingress" {
    for_each = { for rule in flatten(values(local.default_nacl_ingress_rules)) : rule.rule_no => rule }
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = { for rule in flatten(values(local.default_nacl_egress_rules)) : rule.rule_no => rule }
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    {"Name" = format("%s-nacl-default", local.vpc_name)}, 
    var.default_tags
  )
  
  # This lifecycle rule for subnet_ids is required to avoid the changes 
  # that would be reflected in associated subnets ids if Dedicated NACL is not created for subnets
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

##########################################################
## Default Security Group
##########################################################
resource aws_default_security_group "sg_default" {
  vpc_id = aws_vpc.this.id

  # ingress = []
  # egress = []

  dynamic "ingress" {
    for_each = { for rule in flatten(values(local.default_sg_ingress_cidr_rules)) : rule.rule_name => rule }
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks    
    }
  }
  dynamic "ingress" {
    for_each = { for rule in flatten(values(local.default_sg_ingress_self_rules)) : rule.rule_name => rule }
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      self = true    
    }
  }
  dynamic "egress" {
    for_each = { for rule in flatten(values(local.default_sg_egress_rules)) : rule.rule_name => rule }
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks    
    }
  }

  tags = merge(
    {"Name" = format("%s-sg-default", local.vpc_name)}, 
    var.default_tags
  )
}