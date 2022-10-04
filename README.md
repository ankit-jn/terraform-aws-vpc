# ARJ-Stack: AWS VPC Terraform module

A Terraform module for building VPC in AWS.

---
## Resources
This module features the following components to be provisioned with different combinations:

- VPC [[aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)]
    - Secondary CIDR [[aws_vpc_ipv4_cidr_block_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association)]
- DHCP Options Set [[aws_vpc_dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options)] & [[aws_vpc_dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association)]
- Internet Gateway [[aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)]
- egress-only Internet gateway [[aws_egress_only_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway)]
- Subnets [[aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)]
    - Public Subnets
    - Private Subnets (Private in Nature)
    - Outpost Subnets (Private in Nature)
    - Application Subnets (Private in Nature)
    - Database Subnets (Private in Nature)
- Route Tables [[aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)]
    - Subnet Association [[aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)]
    - Routes in Route Table [[aws_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)]
        - IPv4/IPv6 Routes for (egress only) Internet Gateways
        - Nat Gateway
- Dedicated Network ACL [[aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl)]
    - Network ACL Rules [[aws_network_acl_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule)]
- NAT Gateways [[aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)]
- Elastic IPs [[aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)] - to beused by NAT Gateway


- Default Resources
    - Default Security Group [[aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group)]
    - Default Network ACL [[aws_default_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl)]
    - Default Route Table [[aws_default_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table)]

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
| <a name="vpc_name"></a> [vpc_name](#input\_vpc\_name) | The name of the VPC. | `string` | `{}` | yes | |
| <a name="ipv4_cidr_block"></a> [ipv4_cidr_block](#input\_ipv4\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `{}` | no | |
| <a name="enable_ipv6"></a> [enable_ipv6](#input\_enable\_ipv6) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. | `bool` | `{}` | no | |
| <a name="ipv6_cidr_block"></a> [ipv6_cidr_block](#input\_ipv6\_cidr\_block) | IPv6 CIDR block to request from an IPAM Pool. | `string` | `{}` | no | |
| <a name="vpc_base_configs"></a> [vpc_base_configs](#vpc\_base\_configs) | Basic Configuration Map for VPC | `map` | `{}` | no | <pre>vpc_base_configs = {<br>     "enable_ipv6"         = true<br>     "instance_tenancy"    = "default"<br>     "enable_dhcp_options" = false<br>}<pre>|
| <a name="vpc_ipam_configs"></a> [vpc_ipam_configs](#vpc\_ipam\_configs) | Configuration Map for IPAM | `map` |  | no | <pre>vpc_ipam_configs = {<br>     "use_ipv4_ipam_pool"  = "10.0.0.0/16"<br>     "ipv4_ipam_pool_id"   = "ipam-xxxx"<br>     "ipv4_netmask_length" = 28><br>}<pre>|
| <a name="vpc_dns_configs"></a> [vpc_dns_configs](#enable\_vpc\_dns\_configs) | Configuration Map for DNS Support | `map` | <pre>vpc_dns_configs = {<br>     enable_dns_support = true<br>     vpc_dns_host_name  = false<br>}<pre> | no | <pre>vpc_dns_configs = {<br>     enable_dns_support = true<br>     vpc_dns_host_name  = false<br>}<pre> |
| <a name="vpc_classiclink_configs"></a> [vpc_classiclink_configs](#vpc\_classiclink\_configs) | Configuration Map for CLassic Link | `map` | <pre>vpc_classiclink_configs = {<br>     enable_classiclink             = true<br>     enable_classiclink_dns_support = false<br>}<pre> | no | <pre>vpc_classiclink_configs = {<br>     enable_classiclink             = true<br>     enable_classiclink_dns_support = false<br>}<pre> |
| <a name="default_tags"></a> [default_tags](#vpc\_default\_tags) | A map of tags to assign to all the resource. | `map` | `{}` | no | |
| <a name="vpc_tags"></a> [vpc_tags](#vpc\_vpc\_tags) | A map of tags to assign to the VPC. | `map` | `{}` | no | |
| <a name="igw_tags"></a> [igw_tags](#vpc\_igw\_tags) | A map of tags to assign to IGW. | `map` | `{}` | no | |
| <a name="rt_default_tags"></a> [rt_default_tags](#vpc\_rt\_default\_tags) | A map of tags to assign to the route Tables. | `map` | `{}` | no | |
| <a name="subnet_default_tags"></a> [subnet_default_tags](#vpc\_subnet\_default\_tags) | A map of tags to assign to all the subnets. | `map` | `{}` | no | |
| <a name="network_acl_default_tags"></a> [network_acl_default_tags](#vpc\_network\_acl\_default\_tags) | A map of tags to assign to all the Network ACLs. | `map` | `{}` | no | |
| <a name="nat_gateway_tags"></a> [nat_gateway_tags](#vpc\_nat\_gateway\_tags) | A map of tags to assign to all the NAT Gateways. | `map` | `{}` | no | |


## Nested Configuration Maps:  

## vpc_base_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="vpc_name"></a> [vpc_name](#input\_vpc\_name) | The name of the VPC | `map` | `""` | no |
| <a name="use_ipv4_ipam_pool"></a> [use_ipv4_ipam_pool](#input\_use\_ipv4\_ipam\_pool) | Set flag true if use ipam pool for IPv4 CIDRs | `boolean` | `false` | no |
| <a name="enable_ipv6"></a> [enable_ipv6](#input\_enable\_ipv6) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC | `boolean` | `false` | no |
| <a name="use_ipv6_ipam_pool"></a> [use_ipv6_ipam_pool](#input\_use\_ipv6\_ipam\_pool) | Set flag true if use ipam pool for IPv6 CIDRs | `boolean` | `false` | no |
| <a name="instance_tenancy"></a> [instance_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="enable_dhcp_options"></a> [enable_dhcp_options](#input\_enable\_dhcp\_options) | Set it to true if you want to specify a DHCP options set | `boolean` | `false` | no |

## vpc_ipam_configs

Either set the value of property [`ipv4_cidr_block`] to explicitely set CIDR block for VPC or Set the ipam specific properties [`ipv4_ipam_pool_id` and `ipv4_netmask_length`] for deriving CIDR from IPAM 

ipv6 specific properties are only required where enable_ipv6 is set true

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="use_ipv4_ipam_pool"></a> [use_ipv4_ipam_pool](#input\_use\_ipv4\_ipam\_pool) | Set flag true if use ipam pool for IPv4 CIDRs | `boolean` | `false` | no |
| <a name="ipv4_ipam_pool_id"></a> [ipv4_ipam_pool_id](#input\_ipv4\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | no |
| <a name="ipv4_netmask_length"></a> [ipv4_netmask_length](#input\_ipv4\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC. | `number` | `null` | no |
| <a name="use_ipv6_ipam_pool"></a> [use_ipv6_ipam_pool](#input\_use\_ipv6\_ipam\_pool) | Set flag true if use ipam pool for IPv6 CIDRs | `boolean` | `false` | no |
| <a name="ipv6_ipam_pool_id"></a> [ipv6_ipam_pool_id](#input\_ipv6\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | yes |
| <a name="ipv6_netmask_length"></a> [ipv6_netmask_length](#input\_ipv6\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC. | `number` | `null` | no |


## vpc_dns_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="enable_dns_support"></a> [enable_dns_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. | `boolean` | `true` | no |
| <a name="vpc_dns_host_name"></a> [vpc_dns_host_name](#input\_vpc\_dns\_host\_name) | A boolean flag to enable/disable DNS hostnames in the VPC. | `boolean` | `false` | no |

## vpc_classiclink_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="enable_classiclink"></a> [enable_classiclink](#input\_enable\_classiclink) | A boolean flag to enable/disable ClassicLink for the VPC. | `boolean` | `false` | no |
| <a name="enable_classiclink_dns_support"></a> [enable_classiclink_dns_support](#input\_enable\_classiclink\_dns\_support) | A boolean flag to enable/disable ClassicLink DNS Support for the VPC. | `boolean` | `false` | no |

## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-vpc/graphs/contributors).
