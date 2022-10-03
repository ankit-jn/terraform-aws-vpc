# ARJSTAK: AWS VPC Terraform module

A Terraform module for building VPC in AWS.

[![README Header][readme_header_img]][readme_header_link]

[![ARJ-Stack][logo]](https://www.arjstack.com)

---

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
