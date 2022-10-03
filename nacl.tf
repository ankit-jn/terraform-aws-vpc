################################################################
## Public Network ACLs and Network ACL Rules
################################################################

resource aws_network_acl "public" {
    count = (var.dedicated_public_network_acl && (local.public_subnets_count > 0)) ? 1 : 0

    vpc_id     = aws_vpc.this.id
    subnet_ids = values(module.public_subnets.subnets_config)[*].id

    tags = merge(
        {"Name" = format("%s-nacl-public", local.vpc_name)}, 
        var.default_tags, 
        var.network_acl_default_tags
    )
}

resource "aws_network_acl_rule" "public_inbound" {
    for_each = { for rule in flatten(values(local.public_nacl_inbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.public[0].id

    egress          = false
    
    rule_number     = each.value.rule_number
    rule_action     = each.value.rule_action
    from_port       = lookup(each.value, "from_port", null)
    to_port         = lookup(each.value, "to_port", null)
    icmp_code       = lookup(each.value, "icmp_code", null)
    icmp_type       = lookup(each.value, "icmp_type", null)
    protocol        = each.value.protocol
    cidr_block      = lookup(each.value, "cidr_block", null)
    ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
    for_each = { for rule in flatten(values(local.public_nacl_outbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.public[0].id

    egress          = true
    
    rule_number     = each.value.rule_number
    rule_action     = each.value.rule_action
    from_port       = lookup(each.value, "from_port", null)
    to_port         = lookup(each.value, "to_port", null)
    icmp_code       = lookup(each.value, "icmp_code", null)
    icmp_type       = lookup(each.value, "icmp_type", null)
    protocol        = each.value.protocol
    cidr_block      = lookup(each.value, "cidr_block", null)
    ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}

################################################################
## Private Network ACLs and Network ACL Rules
################################################################

resource aws_network_acl "private" {
    count = (var.dedicated_private_network_acl && (local.private_subnets_count > 0)) ? 1 : 0

    vpc_id     = aws_vpc.this.id
    subnet_ids = values(module.private_subnets.subnets_config)[*].id

    tags = merge(
        {"Name" = format("%s-nacl-private", local.vpc_name)}, 
        var.default_tags, 
        var.network_acl_default_tags
    )
}

resource "aws_network_acl_rule" "private_inbound" {
    for_each = { for rule in flatten(values(local.private_nacl_inbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.private[0].id

    egress          = false
    
    rule_number     = each.value.rule_number
    rule_action     = each.value.rule_action
    from_port       = lookup(each.value, "from_port", null)
    to_port         = lookup(each.value, "to_port", null)
    icmp_code       = lookup(each.value, "icmp_code", null)
    icmp_type       = lookup(each.value, "icmp_type", null)
    protocol        = each.value.protocol
    cidr_block      = lookup(each.value, "cidr_block", null)
    ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
    for_each = { for rule in flatten(values(local.private_nacl_outbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.private[0].id

    egress          = true
    
    rule_number     = each.value.rule_number
    rule_action     = each.value.rule_action
    from_port       = lookup(each.value, "from_port", null)
    to_port         = lookup(each.value, "to_port", null)
    icmp_code       = lookup(each.value, "icmp_code", null)
    icmp_type       = lookup(each.value, "icmp_type", null)
    protocol        = each.value.protocol
    cidr_block      = lookup(each.value, "cidr_block", null)
    ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}

################################################################
## Outpost Network ACLs and Network ACL Rules
################################################################

resource aws_network_acl "outpost" {
    count = (var.dedicated_outpost_network_acl && (local.outpost_subnets_count > 0)) ? 1 : 0

    vpc_id     = aws_vpc.this.id
    subnet_ids = values(module.outpost_subnets.subnets_config)[*].id

    tags = merge(
        {"Name" = format("%s-nacl-outpost", local.vpc_name)}, 
        var.default_tags, 
        var.network_acl_default_tags
    )
}

resource "aws_network_acl_rule" "outpost_inbound" {
    for_each = { for rule in flatten(values(local.outpost_nacl_inbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.outpost[0].id

    egress          = false
    
    rule_number     = each.value.rule_number
    rule_action     = each.value.rule_action
    from_port       = lookup(each.value, "from_port", null)
    to_port         = lookup(each.value, "to_port", null)
    icmp_code       = lookup(each.value, "icmp_code", null)
    icmp_type       = lookup(each.value, "icmp_type", null)
    protocol        = each.value.protocol
    cidr_block      = lookup(each.value, "cidr_block", null)
    ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "outpost_outbound" {
    for_each = { for rule in flatten(values(local.outpost_nacl_outbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.outpost[0].id

    egress          = true
    
    rule_number     = each.value.rule_number
    rule_action     = each.value.rule_action
    from_port       = lookup(each.value, "from_port", null)
    to_port         = lookup(each.value, "to_port", null)
    icmp_code       = lookup(each.value, "icmp_code", null)
    icmp_type       = lookup(each.value, "icmp_type", null)
    protocol        = each.value.protocol
    cidr_block      = lookup(each.value, "cidr_block", null)
    ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
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