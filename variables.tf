############
# DEFAULTS #
############
variable "region" {
  type    = string
  default = "uksouth"
}

############
#  APPGW   #
############

variable "frontend_resource_group_name" {
  type        = string
  default     = ""
  description = "Name of the Resource Group holding the frontend CIDR ranges"
}

variable "frontend_virtual_network_name" {
  type        = string
  default     = ""
  description = "Name of the Virtual Nic holding the frontend CIDR ranges"
}

variable "frontend_address_prefixes" {
  type        = list(string)
  default     = []
  description = "Address prefix for the frontend CIDR ranges"
}

variable "backend_resource_group_name" {
  type        = string
  default     = ""
  description = "Name of the Resource Group holding the internal CIDR ranges"
}

variable "backend_virtual_network_name" {
  type        = string
  default     = ""
  description = "Name of the Virtual Nic holding the internal CIDR ranges"
}

variable "backend_address_prefixes" {
  type        = list(string)
  default     = []
  description = "Address prefix for the backend CIDR ranges"
}

variable "sku" {
  description = "The sku pricing model of v1 and v2"
  type = object({
    name     = string
    tier     = string
    capacity = optional(number)
  })
}

variable "autoscale_configuration" {
  description = "Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125"
  type = object({
    min_capacity = number
    max_capacity = optional(number)
  })
  default = null
}

variable "enable_http2" {
  description = "Is HTTP2 enabled on the application gateway resource?"
  default     = false
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = [] #["1", "2", "3"]
}

variable "firewall_policy_id" {
  description = "The ID of the Web Application Firewall Policy which can be associated with app gateway"
  default     = null
}

variable "ssl_policy" {
  description = "Application Gateway SSL configuration"
  type = object({
    disabled_protocols   = optional(list(string))
    policy_type          = optional(string)
    policy_name          = optional(string)
    cipher_suites        = optional(list(string))
    min_protocol_version = optional(string)
  })
  default = null
}

variable "ssl_certificates" {
  description = "List of SSL certificates data for Application gateway"
  type = list(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "authentication_certificates" {
  description = "Authentication certificates to allow the backend with Azure Application Gateway"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_root_certificates" {
  description = "Trusted root certificates to allow the backend with Azure Application Gateway"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "waf_configuration" {
  description = "Web Application Firewall support for your Azure Application Gateway"
  type = object({
    firewall_mode            = string
    rule_set_version         = string
    file_upload_limit_mb     = optional(number)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(number)
    disabled_rule_group = optional(list(object({
      rule_group_name = string
      rules           = optional(list(string))
    })))
    exclusion = optional(list(object({
      match_variable          = string
      selector_match_operator = optional(string)
      selector                = optional(string)
    })))
  })
  default = null
}


############
# TAGGING  #
############

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "costcode" {
  type        = string
  description = "Name of theDWP PRJ number (obtained from the project portfolio in TechNow)"
  default     = ""
}

variable "owner" {
  type        = string
  description = "Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also"
  default     = ""
}

variable "version_number" {
  type        = string
  description = "The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment"
  default     = ""
}

variable "application" {
  type        = string
  description = "Application to which the s3 bucket relates"
  default     = ""
}

variable "attribute" {
  type        = string
  description = "An attribute of the s3 bucket that makes it unique"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment into which resource is deployed"
  default     = ""
}

variable "type" {
  type        = string
  description = "Name of service type"
  default     = ""
}
