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
variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = [] #["1", "2", "3"]
}
