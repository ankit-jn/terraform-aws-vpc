data aws_vpc "this" {
    count = var.create_vpc ? 0 : 1
    
    id = var.vpc_id
}

data aws_internet_gateway "this" {
    count = (!var.create_vpc && local.create_igw_ipv4_route) ? 1 : 0
    filter {
        name   = "attachment.vpc-id"
        values = [var.vpc_id]
    }
}