##########################################################
## Handling Security Group Rules in Default Security Group
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
}