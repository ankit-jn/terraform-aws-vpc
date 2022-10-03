output "route_table_id" {
    description = "The ID of the routing table."
    value = aws_route_table.this.id
}

output "route_table_arn" {
    description = "The ARN of the routing table."
    value = aws_route_table.this.arn
}

output "route_table_owner_id" {
    description = "The ID of the AWS account that owns the route table."
    value = aws_route_table.this.owner_id
}