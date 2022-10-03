################################################################################
# Provision Internet Gateways
################################################################################
resource aws_internet_gateway "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = var.vpc_id

  tags = var.tags
}

resource aws_egress_only_internet_gateway "this" {
  count = var.create_egress_only_igw ? 1 : 0

  vpc_id = var.vpc_id

  tags = var.tags
}