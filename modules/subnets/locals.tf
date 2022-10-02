locals {
    subnet_configs = { for subnet in flatten(var.subnets) : 
        subnet.subnet_core_configs.name => {
            availability_zone = lookup(subnet.subnet_core_configs, "availability_zone", null)
            cidr_block = lookup(subnet.subnet_ip_configs, "cidr_block", null)

            assign_ipv6_address_on_creation = lookup(subnet.subnet_ip_configs, "assign_ipv6_address_on_creation", false)
            ipv6_cidr_block = lookup(subnet.subnet_ip_configs, "ipv6_cidr_block", null)
            ipv6_native = lookup(subnet.subnet_ip_configs, "ipv6_native", false)
            map_public_ip_on_launch = lookup(subnet.subnet_ip_configs, "map_public_ip_on_launch", false)

            #Customer Owned IP Configurations
            map_customer_owned_ip_on_launch = lookup((can(subnet.subnet_customer_owned_ip_configs) ? subnet.subnet_dns_configs : {}), "map_customer_owned_ip_on_launch", false)
            customer_owned_ipv4_pool = lookup((can(subnet.subnet_customer_owned_ip_configs) ? subnet.subnet_dns_configs : {}), "customer_owned_ipv4_pool", null)
            outpost_arn = lookup((can(subnet.subnet_customer_owned_ip_configs) ? subnet.subnet_dns_configs : {}), "outpost_arn", null)

            # DNS Configurations
            enable_dns64 = lookup((can(subnet.subnet_dns_configs) ? subnet.subnet_dns_configs : {}), "enable_dns64", false)
            enable_resource_name_dns_a_record_on_launch = lookup((can(subnet.subnet_dns_configs) ? subnet.subnet_dns_configs : {}), "enable_resource_name_dns_a_record_on_launch", false)
            enable_resource_name_dns_aaaa_record_on_launch = lookup((can(subnet.subnet_dns_configs) ? subnet.subnet_dns_configs : {}), "enable_resource_name_dns_a_record_on_launch", false)
            private_dns_hostname_type_on_launch = lookup((can(subnet.subnet_dns_configs) ? subnet.subnet_dns_configs : {}), "private_dns_hostname_type_on_launch", null)

            tags  = can(subnet.subnet_tags) ? subnet.subnet_tags : {}
        } 
    }
}