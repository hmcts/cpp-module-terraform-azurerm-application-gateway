resource "azurerm_resource_group" "rg1" {
  name     = "${module.tag_set.id}-resource_group"
  location = var.region
}

module "tag_set" {
  source         = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git?ref=main"
  namespace      = var.namespace
  application    = var.application
  costcode       = var.costcode
  owner          = var.owner
  version_number = var.version_number
  attribute      = var.attribute
  environment    = var.environment
  type           = var.type
}

resource "azurerm_subnet" "frontend" {
  name                 = "${module.tag_set.id}-frontend_subnet"
  resource_group_name  = var.frontend_resource_group_name
  virtual_network_name = var.frontend_virtual_network_name
  address_prefixes     = var.frontend_address_prefixes
}

resource "azurerm_subnet" "backend" {
  name                 = "${module.tag_set.id}-backend_subnet"
  resource_group_name  = var.backend_resource_group_name
  virtual_network_name = var.backend_virtual_network_name
  address_prefixes     = var.backend_address_prefixes
}

resource "azurerm_public_ip" "pip1" {
  name                = "${module.tag_set.id}-public_ip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"
  sku                 = "Standard"
  # tags                = var.tags
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "${module.tag_set.id}-appgw"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  enable_http2        = var.enable_http2
  zones               = var.zones
  firewall_policy_id  = var.firewall_policy_id != null ? var.firewall_policy_id : null
  # tags                = var.tags


  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.autoscale_configuration == null ? var.sku.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = lookup(autoscale_configuration.value, "min_capacity")
      max_capacity = lookup(autoscale_configuration.value, "max_capacity")
    }
  }
  gateway_ip_configuration {
    name      = "${module.tag_set.id}-ip_config"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "${module.tag_set.id}-fe-port-80"
    port = 80
  }

  frontend_port {
    name = "${module.tag_set.id}-fe-port-443"
    port = 443
  }
  frontend_ip_configuration {
    name                 = "${module.tag_set.id}-frontend_ip_config"
    public_ip_address_id = azurerm_public_ip.pip1.id
  }

  backend_address_pool {
    name = "${module.tag_set.id}-backend_address_pool"
  }

  backend_http_settings {
    name                  = "${module.tag_set.id}-http_setting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${module.tag_set.id}-listener"
    frontend_ip_configuration_name = "${module.tag_set.id}-frontend_ip_config"
    frontend_port_name             = "${module.tag_set.id}-fe-port-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${module.tag_set.id}-request_routing_rule"
    rule_type                  = "Basic"
    http_listener_name         = "${module.tag_set.id}-listener"
    backend_address_pool_name  = "${module.tag_set.id}-backend_address_pool"
    backend_http_settings_name = "${module.tag_set.id}-http_setting"
    priority                   = 1
  }


  dynamic "ssl_policy" {
    for_each = var.ssl_policy != null ? [var.ssl_policy] : []
    content {
      disabled_protocols   = var.ssl_policy.policy_type == null && var.ssl_policy.policy_name == null ? var.ssl_policy.disabled_protocols : null
      policy_type          = lookup(var.ssl_policy, "policy_type", "Predefined")
      policy_name          = var.ssl_policy.policy_type == "Predefined" ? var.ssl_policy.policy_name : null
      cipher_suites        = var.ssl_policy.policy_type == "Custom" ? var.ssl_policy.cipher_suites : null
      min_protocol_version = var.ssl_policy.min_protocol_version
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configuration != null ? [var.waf_configuration] : []
    content {
      enabled                  = true
      firewall_mode            = lookup(waf_configuration.value, "firewall_mode", "Detection")
      rule_set_type            = "OWASP"
      rule_set_version         = lookup(waf_configuration.value, "rule_set_version", "3.1")
      file_upload_limit_mb     = lookup(waf_configuration.value, "file_upload_limit_mb", 100)
      request_body_check       = lookup(waf_configuration.value, "request_body_check", true)
      max_request_body_size_kb = lookup(waf_configuration.value, "max_request_body_size_kb", 128)

      dynamic "disabled_rule_group" {
        for_each = waf_configuration.value.disabled_rule_group
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }

      dynamic "exclusion" {
        for_each = waf_configuration.value.exclusion
        content {
          match_variable          = exclusion.value.match_variable
          selector_match_operator = exclusion.value.selector_match_operator
          selector                = exclusion.value.selector
        }
      }
    }
  }
}
