resource "azurerm_resource_group" "rg1" {
  name     = "${module.tag_set.id}-resource_group"
  location = var.region
}

module "tag_set" {
  source         = "git::git@github.com:hmcts/cpp-module-terraform-azurerm-tag-generator.git?ref=master"
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
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "${module.tag_set.id}-appgw"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${module.tag_set.id}-ip_config"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "${module.tag_set.id}-frontend_port-name"
    port = 80
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
    frontend_port_name             = "${module.tag_set.id}-frontend_port-name"
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
}
