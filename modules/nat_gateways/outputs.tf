output nat_gatways_config {    
    description = "The Nat gateway Details"
    value = { 
        for nat_key, nat_gatway in aws_nat_gateway.this : 
            nat_key => 
                {
                    id                      = nat_gatway.id
                    allocation_id           = nat_gatway.allocation_id
                    network_interface_id    = nat_gatway.network_interface_id
                    private_ip              = nat_gatway.private_ip
                    public_ip               = nat_gatway.public_ip
                    subnet_id               = nat_gatway.subnet_id
                    subnet_name             = var.nat_gateways[nat_key]
                }
    }
}