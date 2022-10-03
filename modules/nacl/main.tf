################################################################
## Network ACLs and Network ACL Rules
################################################################

resource aws_network_acl "this" {

    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_id

    tags = merge(
        {"Name" = format("%s-nacl-%s", var.vpc_name, var.acl_type)}, 
        var.tags
    )
}

resource "aws_network_acl_rule" "inbound" {
    for_each = { for rule in flatten(values(local.nacl_inbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.this.id

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

resource "aws_network_acl_rule" "outbound" {
    for_each = { for rule in flatten(values(local.nacl_outbound_rules)) : rule.rule_number => rule }
      
    network_acl_id = aws_network_acl.this.id

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