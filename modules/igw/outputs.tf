output "igw" {
    description = "The details of the Internet Gateway."
    value = var.create_igw ? {
        id                      = aws_internet_gateway.this[0].id
        arn                     = aws_internet_gateway.this[0].arn
        availability_zone       = aws_internet_gateway.this[0].owner_id
    } : null

}

output "egress_igw_id" {
    description = "The ID of the egress-only Internet gateway."
    value = var.create_egress_only_igw ? aws_egress_only_internet_gateway.this[0].id : null
}