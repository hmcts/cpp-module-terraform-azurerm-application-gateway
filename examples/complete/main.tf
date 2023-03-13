module "appgw_terratest" {
  source                        = "../../"
  frontend_resource_group_name  = var.frontend_resource_group_name
  frontend_virtual_network_name = var.frontend_virtual_network_name
  frontend_address_prefixes     = var.frontend_address_prefixes
  backend_resource_group_name   = var.backend_resource_group_name
  backend_virtual_network_name  = var.backend_virtual_network_name
  backend_address_prefixes      = var.backend_address_prefixes
  zones                         = var.zones

  sku = {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
  autoscale_configuration = {
    min_capacity = 1
    max_capacity = 15
  }

  # backend_address_pools = [
  #   {
  #     name  = "appgw-testgateway-bapool01"
  #     fqdns = ["example1.com", "example2.com"]
  #   },
  #   {
  #     name         = "appgw-testgateway-bapool02"
  #     ip_addresses = ["1.2.3.4", "2.3.4.5"]
  #   }
  # ]
  # backend_http_settings = [
  #   {
  #     name                  = "appgw-testgateway-be-http-set1"
  #     cookie_based_affinity = "Disabled"
  #     path                  = "/"
  #     enable_https          = true
  #     request_timeout       = 30
  #     # probe_name            = "appgw-testgateway-probe1" # Remove this if `health_probes` object is not defined.
  #     connection_draining = {
  #       enable_connection_draining = true
  #       drain_timeout_sec          = 300

  #     }
  #   },
  #   {
  #     name                  = "appgw-testgateway-be-http-set2"
  #     cookie_based_affinity = "Enabled"
  #     path                  = "/"
  #     enable_https          = false
  #     request_timeout       = 30
  #   }
  # ]
  # http_listeners = [
  #   {
  #     name                 = "appgw-testgateway-be-htln01"
  #     ssl_certificate_name = "appgw-testgateway-ssl01"
  #     host_name            = null
  #   }
  # ]

  # # # Request routing rule is to determine how to route traffic on the listener.
  # # # The rule binds the listener, the back-end server pool, and the backend HTTP settings.
  # # # `Basic` - All requests on the associated listener (for example, blog.contoso.com/*) are forwarded to the associated
  # # # backend pool by using the associated HTTP setting.
  # # # `Path-based` - This routing rule lets you route the requests on the associated listener to a specific backend pool,
  # # # based on the URL in the request.
  # request_routing_rules = [
  #   {
  #     name                       = "appgw-testgateway-be-rqrt"
  #     rule_type                  = "Basic"
  #     http_listener_name         = "appgw-testgateway-be-htln01"
  #     backend_address_pool_name  = "appgw-testgateway-bapool01"
  #     backend_http_settings_name = "appgw-testgateway-be-http-set1"
  #   }
  # ]

  # # TLS termination (previously known as Secure Sockets Layer (SSL) Offloading)
  # # The certificate on the listener requires the entire certificate chain (PFX certificate) to be uploaded to establish the chain of trust.
  # # Authentication and trusted root certificate setup are not required for trusted Azure services such as Azure App Service.
  # ssl_certificates = [{
  #   name     = "appgw-testgateway-ssl01"
  #   data     = "./keyBag.pfx"
  #   password = "P@$$w0rd123"
  # }]

  # WAF configuration, disabled rule groups and exclusions.depends_on
  # The Application Gateway WAF comes pre-configured with CRS 3.0 by default. But you can choose to use CRS 3.2, 3.1, or 2.2.9 instead.
  # CRS 3.2 is only available on the `WAF_v2` SKU.
  waf_configuration = {
    firewall_mode            = "Detection"
    rule_set_version         = "3.1"
    file_upload_limit_mb     = 100
    max_request_body_size_kb = 128

    disabled_rule_group = [
      {
        rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
        rules           = ["930100", "930110"]
      },
      {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rules           = ["920160"]
      }
    ]

    exclusion = [
      {
        match_variable          = "RequestCookieNames"
        selector                = "SomeCookie"
        selector_match_operator = "Equals"
      },
      {
        match_variable          = "RequestHeaderNames"
        selector                = "referer"
        selector_match_operator = "Equals"
      }
    ]
  }

  namespace   = var.namespace
  costcode    = var.costcode
  attribute   = var.attribute
  owner       = var.owner
  environment = var.environment
  application = var.application
  type        = var.type

}

resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic-${count.index + 1}"
  location            = var.region
  resource_group_name = "${var.namespace}-${var.application}-${var.environment}-${var.type}-resource_group"

  ip_configuration {
    name                          = "nic-ipconfig-${count.index + 1}"
    subnet_id                     = module.appgw_terratest.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc01" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "nic-ipconfig-${count.index + 1}"
  backend_address_pool_id = module.appgw_terratest.backend_address_pool_id[0]
}


resource "azurerm_windows_virtual_machine" "vm" {
  count               = 2
  name                = "myVM${count.index + 1}"
  resource_group_name = "cpp-atlassian-nonlive-app_gateway-resource_group"
  location            = "uksouth"
  size                = "Standard_DS1_v2"
  admin_username      = "azureadmin"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vm-extensions" {
  count                = 2
  name                 = "vm${count.index + 1}-ext"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS

}
