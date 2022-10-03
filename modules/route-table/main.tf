###################################################################
## Route Table, Routes and Association to Subnets
###################################################################
resource aws_route_table "this" {
    vpc_id = var.vpc_id

    tags = merge(
        {"Name" = format("%s-rt-%s", var.vpc_name, var.rt_type)}, 
        var.tags
    )
}

resource aws_route "igw_ipv4_route" {
  count = var.create_igw_ipv4_route ? 1 : 0

  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id

  timeouts {
    create = "5m"
  }
}

resource aws_route "igw_ipv6_route" {
  count = var.create_igw_ipv6_route ? 1 : 0

  route_table_id                = aws_route_table.this.id
  destination_ipv6_cidr_block   = "::/0"
  gateway_id                    = var.egress_igw_id

  timeouts {
    create = "5m"
  }
}

resource aws_route_table_association "public" {
  for_each = var.subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.this.id
}