locals {
  # https://docs.microsoft.com/en-gb/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway#exposing-the-developer-portal-externally-through-application-gateway
  disabled_rule_group_settings_dev_portal = [
    {
      rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
      rules = [
        942100,
        942200,
        942110,
        942180,
        942260,
        942340,
        942370,
        942430,
        942440
      ]
    },
    {
      rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
      rules = [
        920300,
        920330
      ]
    },
    {
      rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
      rules = [
        931130
      ]
    }
  ]

  disabled_rule_group_settings = var.disable_waf_rules_for_dev_portal ? concat(local.disabled_rule_group_settings_dev_portal, try(var.waf_configuration.disabled_rule_group, [])) : try(var.waf_configuration.disabled_rule_group, [])

  gateway_ip_configuration_name       = "${lower(var.name)}-gwip"
  frontend_ip_configuration_name      = "${lower(var.name)}-fepip"
  frontend_priv_ip_configuration_name = "${lower(var.name)}-feprivpip"

  frontend_public_ip_config_name  = "frontend_public_ip_configuration"
  frontend_private_ip_config_name = "frontend_private_ip_configuration"

  frontend_ip_configurations = flatten([
    # Public IP configuration (if provided)
    var.frontend_public_ip_address != null ? [
      {
        config_block_name            = local.frontend_public_ip_config_name
        public_ip_id                 = var.frontend_public_ip_address.id
        private_ip                   = null
        private_ip_allocation_method = null
        subnet_id                    = null
      }
    ] : [],

    # Private IP configuration (if provided)
    var.appgw_private ? [
      {
        config_block_name            = local.frontend_private_ip_config_name
        public_ip_id                 = null
        private_ip                   = var.appgw_private_ip
        private_ip_allocation_method = "Static"
        subnet_id                    = var.subnet_id
      }
    ] : []
  ])
}
