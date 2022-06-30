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
  type           = "app_gateway"
}

/* resource "azurerm_virtual_network" "vnet1" {
  name                = "myVNet"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["10.21.0.0/16"]
} */

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

resource "azurerm_application_gateway" "network" {
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

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic-${count.index + 1}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "nic-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc01" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "nic-ipconfig-${count.index + 1}"
  backend_address_pool_id = azurerm_application_gateway.network.backend_address_pool[0].id
}

resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  number  = true
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = 2
  name                = "myVM${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
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
