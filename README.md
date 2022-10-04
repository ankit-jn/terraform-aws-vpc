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

#### VPC specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="vpc_name"></a> [vpc_name](#input\_vpc\_name) | The name of the VPC. | `string` |  | yes | |
| <a name="ipv4_cidr_block"></a> [ipv4_cidr_block](#input\_ipv4\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `0.0.0.0/0` | no | |
| <a name="enable_ipv6"></a> [enable_ipv6](#input\_enable\_ipv6) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. | `bool` | `false` | no | |
| <a name="ipv6_cidr_block"></a> [ipv6_cidr_block](#input\_ipv6\_cidr\_block) | IPv6 CIDR block to request from an IPAM Pool. | `string` | `null` | no | |
| <a name="vpc_base_configs"></a> [vpc_base_configs](#vpc\_base\_configs) | Basic Configuration Map for VPC | `map` | `{}` | no | <pre>vpc_base_configs = {<br>     "enable_ipv6"         = true<br>     "instance_tenancy"    = "default"<br>     "enable_dhcp_options" = false<br>}<pre>|
| <a name="vpc_ipam_configs"></a> [vpc_ipam_configs](#vpc\_ipam\_configs) | Configuration Map for IPAM | `map` |  | no | <pre>vpc_ipam_configs = {<br>     "use_ipv4_ipam_pool"  = "10.0.0.0/16"<br>     "ipv4_ipam_pool_id"   = "ipam-xxxx"<br>     "ipv4_netmask_length" = 28><br>}<pre>|
| <a name="vpc_dns_configs"></a> [vpc_dns_configs](#enable\_vpc\_dns\_configs) | Configuration Map for DNS Support | `map` | <pre>vpc_dns_configs = {<br>     enable_dns_support = true<br>     vpc_dns_host_name  = false<br>}<pre> | no | <pre>vpc_dns_configs = {<br>     enable_dns_support = true<br>     vpc_dns_host_name  = false<br>}<pre> |
| <a name="vpc_classiclink_configs"></a> [vpc_classiclink_configs](#vpc\_classiclink\_configs) | Configuration Map for CLassic Link | `map` | <pre>vpc_classiclink_configs = {<br>     enable_classiclink             = true<br>     enable_classiclink_dns_support = false<br>}<pre> | no | <pre>vpc_classiclink_configs = {<br>     enable_classiclink             = true<br>     enable_classiclink_dns_support = false<br>}<pre> |
| <a name="vpc_secondary_cidr_blocks"></a> [vpc_secondary_cidr_blocks](#vpc\_secondary\_cidr\_blocks) | Configuration Map for Secondary CIDR blocks  | `map` | `{}` | no | <pre>vpc_secondary_cidr_blocks = {<br>     "CIDR-1"   = {<br>           cidr_block = "x.x.x.x/xx<br>     }<br>}<pre> |
| <a name="dhcp_options_domain_name"></a> [dhcp_options_domain_name](#input\_dhcp\_options\_domain\_name) | the suffix domain name to use by default when resolving non Fully Qualified Domain Names. This will require enable_dhcp_options set to true. | `string` | `""` | no | |
| <a name="dhcp_options_domain_name_servers"></a> [dhcp_options_domain_name_servers](#input\_dhcp\_options\_domain\_name\_servers) | List of name servers to configure in /etc/resolv.conf. This will require enable_dhcp_options set to true. | `string` | `["AmazonProvidedDNS"]` | no | |
| <a name="dhcp_options_ntp_servers"></a> [dhcp_options_ntp_servers](#input\_dhcp\_options\_ntp\_servers) | List of NTP servers to configure. This will require enable_dhcp_options set to true. | `list(string)` | `[]` | no | |
| <a name="dhcp_options_netbios_name_servers"></a> [dhcp_options_netbios_name_servers](#input\_dhcp\_options\_netbios\_name\_servers) | List of NETBIOS name servers. This will require enable_dhcp_options set to true. | `list(string)` | `[]` | no | |
| <a name="dhcp_options_netbios_node_type"></a> [dhcp_options_netbios_node_type](#input\_dhcp\_options\_netbios\_node\_type) | The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. This will require enable_dhcp_options set to true. | `string` | `""` | no | |
| <a name="create_igw"></a> [create_igw](#input\_create\_igw) | Flag to set whether to create internet gateway | `boolean` | `true` | no | |
| <a name="create_egress_only_igw"></a> [create_egress_only_igw](#input\_create\_egress\_only\_igw) | Flag to set whether to create Egress only internet gateway | `boolean` | `false` | no | |

#### NACL specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="dedicated_public_network_acl"></a> [dedicated_public_network_acl](#input\_dedicated\_public\_network\_acl) | Set true if dedicated network ACL is required for public subnets. | `boolean` | `false` | no |  |
| <a name="public_nacl_rules"></a> [public_nacl_rules](#nacl\_rules) | Configuration map of Rules for Public Dedicated Network ACL. | `map` | `{}` | no | <pre>{<br>  "inbound" = [<br>     {<br>     rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ],<br>  "outbound" = [<br>     {<br>       rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ]<br>}<pre> |
| <a name="dedicated_private_network_acl"></a> [dedicated_private_network_acl](#input\_dedicated\_private\_network\_acl) | Set true if dedicated network ACL is required for Private subnets. | `boolean` | `false` | no |  |
| <a name="private_nacl_rules"></a> [private_nacl_rules](#nacl\_rules) | Configuration map of Rules for Private Dedicated Network ACL. | `map` | `{}` | no | <pre>{<br>  "inbound" = [<br>     {<br>     rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ],<br>  "outbound" = [<br>     {<br>       rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ]<br>}<pre> |
| <a name="dedicated_outpost_network_acl"></a> [dedicated_outpost_network_acl](#input\_dedicated\_outpost\_network\_acl) | Set true if dedicated network ACL is required for Outpost subnets. | `boolean` | `false` | no |  |
| <a name="outpost_nacl_rules"></a> [outpost_nacl_rules](#nacl\_rules) | Configuration map of Rules for Outpost Dedicated Network ACL. | `map` | `{}` | no | <pre>{<br>  "inbound" = [<br>     {<br>     rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ],<br>  "outbound" = [<br>     {<br>       rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ]<br>}<pre> |
| <a name="dedicated_application_network_acl"></a> [dedicated_application_network_acl](#input\_dedicated\_application\_network\_acl) | Set true if dedicated network ACL is required for Application subnets. | `boolean` | `false` | no |  |
| <a name="application_nacl_rules"></a> [public_nacl_rules](#nacl\_rules) | Configuration map of Rules for Application Dedicated Network ACL. | `map` | `{}` | no | <pre>{<br>  "inbound" = [<br>     {<br>     rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ],<br>  "outbound" = [<br>     {<br>       rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ]<br>}<pre> |
| <a name="dedicated_db_network_acl"></a> [dedicated_db_network_acl](#input\_dedicated\_db\_network\_acl) | Set true if dedicated network ACL is required for Database subnets. | `boolean` | `false` | no |  |

#### NAT Gateways specific properties
---
- The property`nat_gateways` is used to define which public subnet is to be used to provisioned NAT gateway in.
- Purpose of the property `nat_gateway_routes` is that there cold be dedicated route table for subnets i.e. route table for private subnets could be different from the route table for application subnets so which NAT Gateway is to be used as target for the routes in these route table
    - If only single Nat Gateway is provisioned then by default the same will be picked up automatically, hence this property would be skipped

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="nat_gateways"></a> [nat_gateways](#input\_nat\_gateways) | The configuration map of Nat Gateways.<br>Each key will be unique identifier for the Nat Gateway<br> Value will be the subnet name where NAT gateway will be provisioned | `map` | `{}` | no | <pre>nat_gateways = {<br>   "nat-1" = "\<subnet-name\>"<br>   "nat-2" = "\<subnet-name\>"<br>}<pre> |
| <a name="nat_gateway_routes"></a> [nat_gateway_routes](#input\_nat\_gateway\_routes) | The configuration map for associating NAT Gateways in Route tables.<br> There could be 4 keys: <br> - `private-subnets` <br> - `outpost-subnets` <br> - `application-subnets` <br> - `db-subnets` | `map` | `{}` | no | <pre>nat_gateway_routes = {<br>   "private-subnets" = "nat-1"<br>   "db-subnets" = "nat-2"<br>}<pre> |

#### TAG Specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="default_tags"></a> [default_tags](#input\_vpc\_default\_tags) | A map of tags to assign to all the resource. | `map` | `{}` | no | |
| <a name="vpc_tags"></a> [vpc_tags](#input\_vpc\_vpc\_tags) | A map of tags to assign to the VPC. | `map` | `{}` | no | |
| <a name="igw_tags"></a> [igw_tags](#input\_vpc\_igw\_tags) | A map of tags to assign to IGW. | `map` | `{}` | no | |
| <a name="rt_default_tags"></a> [rt_default_tags](#input\_vpc\_rt\_default\_tags) | A map of tags to assign to the route Tables. | `map` | `{}` | no | |
| <a name="subnet_default_tags"></a> [subnet_default_tags](#input\_vpc\_subnet\_default\_tags) | A map of tags to assign to all the subnets. | `map` | `{}` | no | |
| <a name="network_acl_default_tags"></a> [network_acl_default_tags](#input\_vpc\_network\_acl\_default\_tags) | A map of tags to assign to all the Network ACLs. | `map` | `{}` | no | |
| <a name="nat_gateway_tags"></a> [nat_gateway_tags](#input\_vpc\_nat\_gateway\_tags) | A map of tags to assign to all the NAT Gateways. | `map` | `{}` | no | |

#### Default resource specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="db_nacl_rules"></a> [db_nacl_rules](#nacl\_rules) | Configuration map of Rules for Database Dedicated Network ACL. | `map` | `{}` | no | <pre>{<br>  "inbound" = [<br>     {<br>     rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ],<br>  "outbound" = [<br>     {<br>       rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>  ]<br>}<pre> |
| <a name="default_network_acl"></a> [default_network_acl](#nacl\_rules) | Configuration map of Rules for Default Network ACL. | `map` | <pre>{<br>  "inbound" = [<br>     {<br>     rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>     {<br>     rule_number = 101<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "::/0"<br>     },<br>  ],<br>  "outbound" = [<br>     {<br>       rule_number = 100<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "0.0.0.0/0"<br>     },<br>     {<br>     rule_number = 101<br>       rule_action = "allow"<br>       from_port   = 0<br>       to_port     = 0<br>       protocol    = "-1"<br>       cidr_block  = "::/0"<br>     },<br>  ]<br>}<pre> | no |  |
| <a name="default_sg_rules"></a> [default_sg_rules](#sg\_rules) | Configuration List for Security Group Rules of Default Security Group | `list` | `[]` | no | |
| <a name="default_route_table_propagating_vgws"></a> [default_route_table_propagating_vgws](#input\_default\_route\_table\_propagating\_vgws) | List of virtual gateways for propagation. | `list(string)` | `[]` | no | |
| <a name="default_route_table_routes"></a> [default_route_table_routes](#default\_route\_table\_routes) | A List of Configuration map for Routes | `list(map(string))` | `[]` | no | <pre>[<br>     {   <br>        "route_key"      = "rt-1"<br>        "cidr_block"     = "xxx.xxx.xxx.xxx/xx"<br>        "nat_gateway_id" = "nat-xxxx"<br>     },<br>{   <br>        "route_key"            = "rt-2"<br>        "cidr_block"           = "yyy.yyy.yyy.yyy/yy"<br>        "network_interface_id" = "nic-xxxx"<br>     }<br>]<pre> |

## Nested Configuration Maps:  

#### vpc_base_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="instance_tenancy"></a> [instance_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="enable_dhcp_options"></a> [enable_dhcp_options](#input\_enable\_dhcp\_options) | Set it to true if you want to specify a DHCP options set | `boolean` | `false` | no |
| <a name="ipv6_cidr_block_network_border_group"></a> [ipv6_cidr_block_network_border_group](#input\_ipv6\_cidr\_block\_network\_border\_group) | By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC. | `number` | `null` | no |

#### vpc_ipam_configs

Either set the value of property [`ipv4_cidr_block`] to explicitly set CIDR block for VPC or Set the ipam specific properties [`ipv4_ipam_pool_id` and `ipv4_netmask_length`] for deriving CIDR from IPAM 

ipv6 specific properties are only required where enable_ipv6 is set true

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="use_ipv4_ipam_pool"></a> [use_ipv4_ipam_pool](#input\_use\_ipv4\_ipam\_pool) | Set flag true if use ipam pool for IPv4 CIDRs | `boolean` | `false` | no |
| <a name="ipv4_ipam_pool_id"></a> [ipv4_ipam_pool_id](#input\_ipv4\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | no |
| <a name="ipv4_netmask_length"></a> [ipv4_netmask_length](#input\_ipv4\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC. | `number` | `null` | no |
| <a name="use_ipv6_ipam_pool"></a> [use_ipv6_ipam_pool](#input\_use\_ipv6\_ipam\_pool) | Set flag true if use ipam pool for IPv6 CIDRs | `boolean` | `false` | no |
| <a name="ipv6_ipam_pool_id"></a> [ipv6_ipam_pool_id](#input\_ipv6\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | yes |
| <a name="ipv6_netmask_length"></a> [ipv6_netmask_length](#input\_ipv6\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC. | `number` | `null` | no |


#### vpc_dns_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="enable_dns_support"></a> [enable_dns_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. | `boolean` | `true` | no |
| <a name="vpc_dns_host_name"></a> [vpc_dns_host_name](#input\_vpc\_dns\_host\_name) | A boolean flag to enable/disable DNS hostnames in the VPC. | `boolean` | `false` | no |

#### vpc_classiclink_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="enable_classiclink"></a> [enable_classiclink](#input\_enable\_classiclink) | A boolean flag to enable/disable ClassicLink for the VPC. | `boolean` | `false` | no |
| <a name="enable_classiclink_dns_support"></a> [enable_classiclink_dns_support](#input\_enable\_classiclink\_dns\_support) | A boolean flag to enable/disable ClassicLink DNS Support for the VPC. | `boolean` | `false` | no |

#### vpc_secondary_cidr_blocks

Each entry of this Map will be a Map again for Secondary CIDR configuration (Either set CIDR block explicitly or define IPAM Pool ID) where,
Map Key - Any unique string identifier
Map Values - A map of CIDR configurations with the following properties:

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="cidr_block"></a> [cidr_block](#input\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `null` | no |
| <a name="ipam_pool_id"></a> [ipam_pool_id](#input\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | no |
| <a name="netmask_length"></a> [enable_classiclink](#input\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC. | `number` | `null` | no |

#### nacl_rules

NACL rules are managed as a map of 2 different rule types where<br>
Map key - Rule Type [There could be 2 Rule Types : `inbound`, `outbound`]<br>
Map Value - An array of Rule Maps as defined below<br><br>

Each this block should be defined as an entry of the list managed under Map key - either `inbound` or `outbound`<br>

One of `cidr_block` and `ipv6_cidr_block` is mandatory

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="rule_no"></a> [rule_no](#input\_rule\_no) | Rule Number | `number` |  | yes |
| <a name="action"></a> [action](#input\_action) | Rule Action [allow/deny]. | `string` |  | yes |
| <a name="from_port"></a> [from_port](#input\_from\_port) | Traffic from port | `string` |  | yes |
| <a name="to_port"></a> [to_port](#input\_to\_port) | Traffic to port | `string` |  | yes |
| <a name="protocol"></a> [protocol](#input\_protocol) | Protocol Name | `string` |  | yes |
| <a name="cidr_block"></a> [cidr_block](#input\_cidr\_block) | IPv4 CIDR block. | `string` | `null` | no |
| <a name="ipv6_cidr_block"></a> [nat_gateway_id](#input\_ipv6\_cidr\_block) | IPv6 CIDR block | `string` | `null` | no |

#### default_route_table_routes

Each entry of this List will be a Map again with the following entries.

Destination - One of the following keys [`cidr_block` and `ipv6_cidr_block`] is mandatory.<br>
Target - One of the following keys [`core_network_arn`, `egress_only_gateway_id`, `gateway_id`, `instance_id`, `nat_gateway_id`, `network_interface_id`, `transit_gateway_id`, `vpc_endpoint_id`, `vpc_peering_connection_id`,] is mandatory

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="cidr_block"></a> [cidr_block](#input\_cidr\_block) | The IPv4 CIDR block of the route. | `string` | `null` | no |
| <a name="ipv6_cidr_block"></a> [ipv6_cidr_block](#input\_ipv6\_cidr\_block) | The IPv6 CIDR block of the route. | `string` | `null` | no |
| <a name="core_network_arn"></a> [core_network_arn](#input\_core\_network\_arn) | The Amazon Resource Name (ARN) of a core network. | `string` | `null` | no |
| <a name="egress_only_gateway_id"></a> [egress_only_gateway_id](#input\_egress\_only\_gateway\_id) | Identifier of a VPC Egress Only Internet Gateway. | `string` | `null` | no |
| <a name="gateway_id"></a> [gateway_id](#input\_gateway\_id) | Identifier of a VPC internet gateway or a virtual private gateway. | `string` | `null` | no |
| <a name="instance_id"></a> [instance_id](#input\_instance\_id) | Identifier of an EC2 instance. | `string` | `null` | no |
| <a name="nat_gateway_id"></a> [nat_gateway_id](#input\_nat\_gateway\_id) | Identifier of a VPC NAT gateway. | `string` | `null` | no |
| <a name="network_interface_id"></a> [network_interface_id](#input\_network\_interface\_id) | Identifier of an EC2 network interface. | `string` | `null` | no |
| <a name="transit_gateway_id"></a> [transit_gateway_id](#input\_transit\_gateway\_id) | Identifier of an EC2 Transit Gateway. | `string` | `null` | no |
| <a name="vpc_endpoint_id"></a> [vpc_endpoint_id](#input\_vpc\_endpoint\_id) | Identifier of a VPC Endpoint. | `string` | `null` | no |
| <a name="vpc_peering_connection_id"></a> [vpc_peering_connection_id](#input\_vpc\_peering\_connection\_id) | Identifier of a VPC peering connection. | `string` | `null` | no |

#### sg_rules

SG rules are managed as a map of 3 different rule types where<br>
Map key - Rule Type [There could be 2 Rule Types : `ingress-cidr`, `ingress-self`, `egress`]<br>
Map Value - An array of Rule Maps as defined below<br><br>

- Each this block should be defined as an entry of the list managed under Map key - either `ingress-cidr` or `ingress-self` or `egress`<br>
- cidr_blocks is not required if it is `ingress-self` rule

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="rule_name"></a> [rule_name](#input\_rule\_name) | Rule name | `number` |  | yes |
| <a name="from_port"></a> [from_port](#input\_from\_port) | Traffic from port | `number` |  | yes |
| <a name="to_port"></a> [to_port](#input\_to\_port) | Traffic to port | `number` |  | yes |
| <a name="protocol"></a> [protocol](#input\_protocol) | protocol name | `string` |  | yes |
| <a name="cidr_blocks"></a> [cidr_blocks](#input\_cidr\_blocks) | Rule Number | `string` |  | no |

## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-vpc/graphs/contributors).
