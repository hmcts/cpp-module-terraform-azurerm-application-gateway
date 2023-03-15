frontend_resource_group_name  = "RG-LAB-INT-01"
frontend_virtual_network_name = "VN-LAB-INT-01"
frontend_address_prefixes     = ["10.1.7.0/28"]
backend_resource_group_name   = "RG-LAB-INT-01"
backend_virtual_network_name  = "VN-LAB-INT-01"
backend_address_prefixes      = ["10.1.14.0/28"]
zones                         = ["2"]

namespace   = "cpp"
costcode    = "terratest"
attribute   = ""
owner       = "EI"
environment = "nonlive"
application = "atlassian"
type        = "app_gateway"


# frontend_resource_group_name  = "RG-LAB-DMZ-01"
# frontend_virtual_network_name = "VN-LAB-DMZ-01"
# frontend_address_prefixes     = ["10.4.4.0/28"]
