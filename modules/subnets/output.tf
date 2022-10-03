output subnets_config {    
    description = "The Subnet Details"
    value = { 
        for subney_key, subnet in aws_subnet.this : 
            subney_key => 
                {
                    id                      = subnet.id
                    arn                     = subnet.arn
                    availability_zone       = subnet.availability_zone
                    availability_zone_id    = subnet.availability_zone_id
                }
    }
}