# ARJSTAK: AWS VPC Terraform module

A Terraform module for building VPC in AWS.

---
## Resources
This module features the following components to be provisioned with different combinations:

- VPC [`aws_vpc`]
    - Secondary CIDR [`aws_vpc_ipv4_cidr_block_association`]
- DHCP Options Set [`aws_vpc_dhcp_options` & `aws_vpc_dhcp_options_association`]
- Internet Gateway [`aws_internet_gateway`]
- egress-only Internet gateway [`aws_egress_only_internet_gateway`]
- Subnets [`aws_subnet`]
    - Public Subnets
    - Private Subnets (Private in Nature)
    - Outpost Subnets (Private in Nature)
    - Application Subnets (Private in Nature)
    - Database Subnets (Private in Nature)
- Route Tables [`aws_route_table`]
    - Subnet Association [`aws_route_table_association`]
    - Routes in Route Table [`aws_route`]
        - IPv4/IPv6 Routes for (egress only) Internet Gateways
        - Nat Gateway
- Dedicated Network ACL [`aws_network_acl`]
    - Network ACL Rules [`aws_network_acl_rule`]
- NAT Gateways [`aws_nat_gateway`]
- Elastic IPs [`aws_eip`] - to beused by NAT Gateway


- Default Resources
    - Default Security Group [`aws_default_security_group`]
    - Default Network ACL [`aws_default_network_acl`]
    - Default Route Table [`aws_default_route_table`]

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Inputs

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="vpc_base_configs"></a> [vpc_base_configs](#vpc\_base\_configs) | Basic Configuration Map for VPC | `map` | `{}` | no | <pre>vpc_base_configs = {<br>     "vpc_name"            = "my-vpc"<br>     "use_ipv4_ipam_pool"  = false<br>     "enable_ipv6"         = true<br>     "use_ipv6_ipam_pool"  = false<br>     "instance_tenancy"    = "default"<br>     "enable_dhcp_options" = false<br>}<pre>|


## Nested Configuration Maps:  

## vpc_base_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="vpc_name"></a> [vpc_name](#input\_vpc\_name) | The name of the VPC | `map` | `""` | no |
| <a name="use_ipv4_ipam_pool"></a> [use_ipv4_ipam_pool](#input\_use\_ipv4\_ipam\_pool) | Set flag true if use ipam pool for IPv4 CIDRs | `boolean` | `false` | no |
| <a name="enable_ipv6"></a> [enable_ipv6](#input\_enable\_ipv6) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC | `boolean` | `false` | no |
| <a name="use_ipv6_ipam_pool"></a> [use_ipv6_ipam_pool](#input\_use\_ipv6\_ipam\_pool) | Set flag true if use ipam pool for IPv6 CIDRs | `boolean` | `false` | no |
| <a name="instance_tenancy"></a> [instance_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="enable_dhcp_options"></a> [enable_dhcp_options](#enable\_dhcp\_options) | Set it to true if you want to specify a DHCP options set | `boolean` | `false` | no |

## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-vpc/graphs/contributors).
