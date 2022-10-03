locals {
    nacl_inbound_rules = { for k, v in var.nacl_rules : k => v if k == "inbound" }
    nacl_outbound_rules = { for k, v in var.nacl_rules : k => v if k == "outbound" }
}