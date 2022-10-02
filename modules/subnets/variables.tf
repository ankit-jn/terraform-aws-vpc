variable "vpc_id" {
    description = "(Required) The ID of the VPC"
    type = string
}

variable "subnets" {
    type = list

    description = <<EOF
(Required) The configuration Map of Subnets 

Map Key - Anything unique (recommended - Subnet Name)
Map Value - This would be another map of the following key values:

1. subnet_core_configs: (Required) This is again a Map of the Core settings for the subnet with the following keys:

1.1. vpc_id - (Required) The VPC ID.
1.2. name - (Required) The name of the subnet
1.3. availability_zone - (Optional) AZ for the subnet.

2. subnet_ip_configs: (Optional) This is again a Map of the IPv4/IPv6 settings for the subnet with the following keys:

2.1. cidr_block - (Optional) The IPv4 CIDR block for the subnet.
2.2. assign_ipv6_address_on_creation - (Optional) Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address.
2.3. ipv6_cidr_block - (Optional) The IPv6 network range for the subnet, in CIDR notation.
2.4. ipv6_native - (Optional) Indicates whether to create an IPv6-only subnet.
2.5. map_public_ip_on_launch - (Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address.


3. subnet_customer_owned_ip_configs: (Optional) This is again a Map of the Customer Owned IP settings for the subnet with the following keys:

3.1. map_customer_owned_ip_on_launch - (Optional) Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address.
3.2. customer_owned_ipv4_pool - (Optional) The customer owned IPv4 address pool.
3.3. vpc_dns_host_name - (Optional) The Amazon Resource Name (ARN) of the Outpost.

4. subnet_dns_configs: (Optional) This is again a Map of the DNS settings for the subnet with the following keys:

4.1. enable_dns64 - (Optional) Indicates whether DNS queries made to the Amazon-provided DNS Resolver 
                       in this subnet should return synthetic IPv6 addresses for IPv4-only destinations.
4.2. enable_resource_name_dns_a_record_on_launch - (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS A records.
4.3. enable_resource_name_dns_aaaa_record_on_launch - (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records.

4.4. private_dns_hostname_type_on_launch - (Optional) The type of hostnames to assign to instances in the subnet at launch.

5. subnet_tags: (Optional) A map of tags to assign to the resource."

Example:
    subnets = {
        "sn-test-1" = {
            subnet_core_configs = {
                vpc_id = "vpc-xxxxx"
                name = "sn-test-1"
                cidr_block = "x.x.x.x/xx"
            }

            subnet_ip_configs = {
                // all properties ...
            }

            subnet_customer_owned_ip_configs = {
                // all properties ...
            }
            
            subnet_tags = {
                // all key/value tags
            }
        },
    }
EOF
}

variable "default_tags" {
    description = "(Optional) The map of the default tags"
    type = map
    default = {}
}