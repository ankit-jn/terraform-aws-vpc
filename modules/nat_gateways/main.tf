############################################
## Provision Elastic IP for each NatGateway
############################################
resource aws_eip "nat_eips" {
    for_each = var.nat_gateways

    vpc = true
    tags = merge(
            {"Name" = format("%s-eip-%s", var.vpc_name, each.key)}, 
            var.tags
          )
}

############################################
## Provision NatGayways
############################################
resource aws_nat_gateway "this" {
    for_each = var.nat_gateways

    allocation_id = aws_eip.nat_eips[each.key].id
    subnet_id = var.subnets[each.value].id

    tags = merge(
            {"Name" = format("%s-nat-%s", var.vpc_name, each.key)}, 
            var.tags
          )
}