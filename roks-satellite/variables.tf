variable "project_name" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "resource_group" {
  type    = string
}

variable "ibm_region" {
  type    = string
}

variable "location" {
  type    = string
}

variable "cluster_name" {
  type    = string
  default = null
}

variable "cluster_zones" {
  type    = list(string)
  default = ["us-south-1", "us-south-2", "us-south-3"]
}

variable "enable_custom_subnet" {
  type    = bool
}

variable "enable_custom_address_prefix" {
  type    = bool
}

variable "subnet_cidr" {
  type    = list(string)
}

variable "address_prefix_cidr" {
  type    = list(string)
}

variable "enable_public_gateway" {
  type    = bool
}

variable "managed_from" {
  type    = string
  default = "dal"
}

variable "location_zones" {
  type    = list(string)
  default = ["us-south-1", "us-south-2", "us-south-3"]
}

variable "location_bucket" {
  type    = string
  default = null
}

variable "is_location_exist" {
  type    = bool
  default = false
}

variable "host_labels" {
  type    = list(string)
  default = ["env:dev"]

  validation {
    condition     = can([for s in var.host_labels : regex("^[a-zA-Z0-9:]+$", s)])
    error_message = "Label must be of the form `key:value`."
  }
}

variable "host_profile" {
  type    = string
  default = "bx2-4x16"
}

variable "cluster_host_profile" {
  type    = string
  default = "bx2-8x32"
}

variable "host_count" {
  type    = number
  default = 3
}

variable "cluster_host_count" {
  type    = number
  default = 3
}

variable "public_key" {
  type    = string
  default = null
}

variable "cluster_enable_config_admin" {
  type    = bool
  default = true
}

variable "ocp_version" {
  type    = string
  default = "4.7_openshift"
}

variable "host_provider" {
  type    = string
  default = "ibm"
}

locals {
  max_size = length(var.location_zones)
}