module "appgw_terratest" {
  source                        = "../../"
  frontend_resource_group_name  = var.frontend_resource_group_name
  frontend_virtual_network_name = var.frontend_virtual_network_name
  frontend_address_prefixes     = var.frontend_address_prefixes
  backend_resource_group_name   = var.backend_resource_group_name
  backend_virtual_network_name  = var.backend_virtual_network_name
  backend_address_prefixes      = var.backend_address_prefixes

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
  number  = true
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
  backend_address_pool_id = module.appgw_terratest.backend_address_pool_id
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
