README.md updated successfully
rements

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =3.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tag_set"></a> [tag\_set](#module\_tag\_set) | git::git@github.com:hmcts/cpp-module-terraform-azurerm-tag-generator.git | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.14.0/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.pip1](https://registry.terraform.io/providers/hashicorp/azurerm/3.14.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg1](https://registry.terraform.io/providers/hashicorp/azurerm/3.14.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.backend](https://registry.terraform.io/providers/hashicorp/azurerm/3.14.0/docs/resources/subnet) | resource |
| [azurerm_subnet.frontend](https://registry.terraform.io/providers/hashicorp/azurerm/3.14.0/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application to which the s3 bucket relates | `string` | `""` | no |
| <a name="input_attribute"></a> [attribute](#input\_attribute) | An attribute of the s3 bucket that makes it unique | `string` | `""` | no |
| <a name="input_backend_address_prefixes"></a> [backend\_address\_prefixes](#input\_backend\_address\_prefixes) | Address prefix for the backend CIDR ranges | `list(string)` | `[]` | no |
| <a name="input_backend_resource_group_name"></a> [backend\_resource\_group\_name](#input\_backend\_resource\_group\_name) | Name of the Resource Group holding the internal CIDR ranges | `string` | `""` | no |
| <a name="input_backend_virtual_network_name"></a> [backend\_virtual\_network\_name](#input\_backend\_virtual\_network\_name) | Name of the Virtual Nic holding the internal CIDR ranges | `string` | `""` | no |
| <a name="input_costcode"></a> [costcode](#input\_costcode) | Name of theDWP PRJ number (obtained from the project portfolio in TechNow) | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment into which resource is deployed | `string` | `""` | no |
| <a name="input_frontend_address_prefixes"></a> [frontend\_address\_prefixes](#input\_frontend\_address\_prefixes) | Address prefix for the frontend CIDR ranges | `list(string)` | `[]` | no |
| <a name="input_frontend_resource_group_name"></a> [frontend\_resource\_group\_name](#input\_frontend\_resource\_group\_name) | Name of the Resource Group holding the frontend CIDR ranges | `string` | `""` | no |
| <a name="input_frontend_virtual_network_name"></a> [frontend\_virtual\_network\_name](#input\_frontend\_virtual\_network\_name) | Name of the Virtual Nic holding the frontend CIDR ranges | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | ########### DEFAULTS # ########### | `string` | `"uksouth"` | no |
| <a name="input_type"></a> [type](#input\_type) | Name of service type | `string` | `""` | no |
| <a name="input_version_number"></a> [version\_number](#input\_version\_number) | The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment | `string` | `""` | no |

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
