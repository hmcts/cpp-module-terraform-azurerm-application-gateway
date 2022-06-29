# terraform-module-template

<!-- TODO fill in resource name in link to product documentation -->
Terraform module for [Resource name](https://example.com).

## Example

<!-- todo update module name
```hcl
module "todo_resource_name" {
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible?ref=master"
  ...
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1.1 |

## Resources

| Name | Type |
|------|------|
| [null_resource.null_resource_simple](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
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
