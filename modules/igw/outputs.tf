output "igw_configs" {
    description = "The details of the Internet Gateway."
    value = {
        id                      = try(aws_internet_gateway.this[0].id, "")
        arn                     = try(aws_internet_gateway.this[0].arn, "")
        availability_zone       = try(aws_internet_gateway.this[0].owner_id, "")
    }
}

output "egress_igw_id" {
    description = "The ID of the egress-only Internet gateway."
    value = try(aws_egress_only_internet_gateway.this[0].id, "")
}