README.md updated successfully
rements

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.99.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =2.99.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tag_set"></a> [tag\_set](#module\_tag\_set) | git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git | main |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.pip1](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg1](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.backend](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/subnet) | resource |
| [azurerm_subnet.frontend](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_gateway_name"></a> [app\_gateway\_name](#input\_app\_gateway\_name) | The name of the application gateway | `string` | `""` | no |
| <a name="input_application"></a> [application](#input\_application) | Application to which the s3 bucket relates | `string` | `""` | no |
| <a name="input_attribute"></a> [attribute](#input\_attribute) | An attribute of the s3 bucket that makes it unique | `string` | `""` | no |
| <a name="input_authentication_certificates"></a> [authentication\_certificates](#input\_authentication\_certificates) | Authentication certificates to allow the backend with Azure Application Gateway | <pre>list(object({<br>    name = string<br>    data = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscale_configuration"></a> [autoscale\_configuration](#input\_autoscale\_configuration) | Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125 | <pre>object({<br>    min_capacity = number<br>    max_capacity = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | List of backend address pools | <pre>list(object({<br>    name         = string<br>    fqdns        = optional(list(string))<br>    ip_addresses = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_backend_address_prefixes"></a> [backend\_address\_prefixes](#input\_backend\_address\_prefixes) | Address prefix for the backend CIDR ranges | `list(string)` | `[]` | no |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | List of backend HTTP settings. | <pre>list(object({<br>    name                                = string<br>    cookie_based_affinity               = string<br>    affinity_cookie_name                = optional(string)<br>    path                                = optional(string)<br>    enable_https                        = bool<br>    probe_name                          = optional(string)<br>    request_timeout                     = number<br>    host_name                           = optional(string)<br>    pick_host_name_from_backend_address = optional(bool)<br>    authentication_certificate = optional(object({<br>      name = string<br>    }))<br>    trusted_root_certificate_names = optional(list(string))<br>    connection_draining = optional(object({<br>      enable_connection_draining = bool<br>      drain_timeout_sec          = number<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_backend_resource_group_name"></a> [backend\_resource\_group\_name](#input\_backend\_resource\_group\_name) | Name of the Resource Group holding the internal CIDR ranges | `string` | `""` | no |
| <a name="input_backend_virtual_network_name"></a> [backend\_virtual\_network\_name](#input\_backend\_virtual\_network\_name) | Name of the Virtual Nic holding the internal CIDR ranges | `string` | `""` | no |
| <a name="input_costcode"></a> [costcode](#input\_costcode) | Name of theDWP PRJ number (obtained from the project portfolio in TechNow) | `string` | `""` | no |
| <a name="input_custom_error_configuration"></a> [custom\_error\_configuration](#input\_custom\_error\_configuration) | Global level custom error configuration for application gateway | `list(map(string))` | `[]` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Is HTTP2 enabled on the application gateway resource? | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment into which resource is deployed | `string` | `""` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | The ID of the Web Application Firewall Policy which can be associated with app gateway | `any` | `null` | no |
| <a name="input_frontend_address_prefixes"></a> [frontend\_address\_prefixes](#input\_frontend\_address\_prefixes) | Address prefix for the frontend CIDR ranges | `list(string)` | `[]` | no |
| <a name="input_frontend_resource_group_name"></a> [frontend\_resource\_group\_name](#input\_frontend\_resource\_group\_name) | Name of the Resource Group holding the frontend CIDR ranges | `string` | `""` | no |
| <a name="input_frontend_virtual_network_name"></a> [frontend\_virtual\_network\_name](#input\_frontend\_virtual\_network\_name) | Name of the Virtual Nic holding the frontend CIDR ranges | `string` | `""` | no |
| <a name="input_health_probes"></a> [health\_probes](#input\_health\_probes) | List of Health probes used to test backend pools health. | <pre>list(object({<br>    name                                      = string<br>    host                                      = string<br>    interval                                  = number<br>    path                                      = string<br>    timeout                                   = number<br>    unhealthy_threshold                       = number<br>    port                                      = optional(number)<br>    pick_host_name_from_backend_http_settings = optional(bool)<br>    minimum_servers                           = optional(number)<br>    match = optional(object({<br>      body        = optional(string)<br>      status_code = optional(list(string))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | List of HTTP/HTTPS listeners. SSL Certificate name is required | <pre>list(object({<br>    name                 = string<br>    host_name            = optional(string)<br>    host_names           = optional(list(string))<br>    require_sni          = optional(bool)<br>    ssl_certificate_name = optional(string)<br>    firewall_policy_id   = optional(string)<br>    ssl_profile_name     = optional(string)<br>    custom_error_configuration = optional(list(object({<br>      status_code           = string<br>      custom_error_page_url = string<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list with a single user managed identity id to be assigned to the Application Gateway | `any` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also | `string` | `""` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Private IP Address to assign to the Load Balancer. | `any` | `null` | no |
| <a name="input_redirect_configuration"></a> [redirect\_configuration](#input\_redirect\_configuration) | list of maps for redirect configurations | `list(map(string))` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | ########### DEFAULTS # ########### | `string` | `"uksouth"` | no |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | List of Request routing rules to be used for listeners. | <pre>list(object({<br>    name                        = string<br>    rule_type                   = string<br>    http_listener_name          = string<br>    backend_address_pool_name   = optional(string)<br>    backend_http_settings_name  = optional(string)<br>    redirect_configuration_name = optional(string)<br>    rewrite_rule_set_name       = optional(string)<br>    url_path_map_name           = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_rewrite_rule_set"></a> [rewrite\_rule\_set](#input\_rewrite\_rule\_set) | List of rewrite rule set including rewrite rules | `any` | `[]` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku pricing model of v1 and v2 | <pre>object({<br>    name     = string<br>    tier     = string<br>    capacity = optional(number)<br>  })</pre> | n/a | yes |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | List of SSL certificates data for Application gateway | <pre>list(object({<br>    name                = string<br>    data                = optional(string)<br>    password            = optional(string)<br>    key_vault_secret_id = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Application Gateway SSL configuration | <pre>object({<br>    disabled_protocols   = optional(list(string))<br>    policy_type          = optional(string)<br>    policy_name          = optional(string)<br>    cipher_suites        = optional(list(string))<br>    min_protocol_version = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_trusted_root_certificates"></a> [trusted\_root\_certificates](#input\_trusted\_root\_certificates) | Trusted root certificates to allow the backend with Azure Application Gateway | <pre>list(object({<br>    name = string<br>    data = string<br>  }))</pre> | `[]` | no |
| <a name="input_type"></a> [type](#input\_type) | Name of service type | `string` | `""` | no |
| <a name="input_url_path_maps"></a> [url\_path\_maps](#input\_url\_path\_maps) | List of URL path maps associated to path-based rules. | <pre>list(object({<br>    name                                = string<br>    default_backend_http_settings_name  = optional(string)<br>    default_backend_address_pool_name   = optional(string)<br>    default_redirect_configuration_name = optional(string)<br>    default_rewrite_rule_set_name       = optional(string)<br>    path_rules = list(object({<br>      name                        = string<br>      backend_address_pool_name   = optional(string)<br>      backend_http_settings_name  = optional(string)<br>      paths                       = list(string)<br>      redirect_configuration_name = optional(string)<br>      rewrite_rule_set_name       = optional(string)<br>      firewall_policy_id          = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_version_number"></a> [version\_number](#input\_version\_number) | The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment | `string` | `""` | no |
| <a name="input_waf_configuration"></a> [waf\_configuration](#input\_waf\_configuration) | Web Application Firewall support for your Azure Application Gateway | <pre>object({<br>    firewall_mode            = string<br>    rule_set_version         = string<br>    file_upload_limit_mb     = optional(number)<br>    request_body_check       = optional(bool)<br>    max_request_body_size_kb = optional(number)<br>    disabled_rule_group = optional(list(object({<br>      rule_group_name = string<br>      rules           = optional(list(string))<br>    })))<br>    exclusion = optional(list(object({<br>      match_variable          = string<br>      selector_match_operator = optional(string)<br>      selector                = optional(string)<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A collection of availability zones to spread the Application Gateway over. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appgw_id"></a> [appgw\_id](#output\_appgw\_id) | The ID of the Application Gateway. |
| <a name="output_appgw_name"></a> [appgw\_name](#output\_appgw\_name) | The name of the Application Gateway. |
| <a name="output_appgw_public_ip_address"></a> [appgw\_public\_ip\_address](#output\_appgw\_public\_ip\_address) | The public IP address of Application Gateway. |
| <a name="output_backend_address_pool_id"></a> [backend\_address\_pool\_id](#output\_backend\_address\_pool\_id) | The backend address pool id |
| <a name="output_backend_subnet_id"></a> [backend\_subnet\_id](#output\_backend\_subnet\_id) | The backend subnet id |
<!-- END_TF_DOCS -->
## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
