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
  
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}