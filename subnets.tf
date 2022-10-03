
###############################
## Provision Subnets of the VPC
###############################

# Public Subnets
module "public_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.public_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)
}

# Private Subnets
module "private_subnets" {
    source = "./modules/subnets"
    
    vpc_id = aws_vpc.this.id
    subnets = local.private_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)
}

# Outpost Subnets
module "outpost_subnets" {
    source = "./modules/subnets"

    vpc_id = aws_vpc.this.id
    subnets = local.outpost_subnets
    default_tags = merge(var.default_tags, var.subnet_default_tags)
}