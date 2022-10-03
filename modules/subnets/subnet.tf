###############################
## Provision Map of Subnets
###############################
resource aws_subnet "this" {
    
    for_each = local.subnet_configs

    vpc_id = var.vpc_id
    availability_zone = each.value.availability_zone
    
    cidr_block = each.value.cidr_block

    # Customer Owned CIDR
    map_customer_owned_ip_on_launch = each.value.map_customer_owned_ip_on_launch ? true : null
    customer_owned_ipv4_pool = each.value.customer_owned_ipv4_pool
    outpost_arn = each.value.outpost_arn
    
    assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation
    ipv6_cidr_block = each.value.ipv6_cidr_block
    ipv6_native = each.value.ipv6_native
    
    map_public_ip_on_launch = each.value.map_public_ip_on_launch
    
    enable_dns64 = each.value.enable_dns64
    enable_resource_name_dns_a_record_on_launch = each.value.enable_resource_name_dns_a_record_on_launch
    enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch
    private_dns_hostname_type_on_launch = each.value.private_dns_hostname_type_on_launch
    
    tags = merge({"Name" = format("%s", each.key)}, var.default_tags, each.value.tags)
}
