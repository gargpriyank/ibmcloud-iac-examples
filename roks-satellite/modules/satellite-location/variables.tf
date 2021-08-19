variable "resource_group" {
  type    = string
}

variable "ibm_region" {
  type    = string
  default = null
}

variable "location" {
  type    = string
}

variable "is_location_exist" {
  type    = bool
  default = false
}

variable "managed_from" {
  type    = string
  default = "dal"
}

variable "location_zones" {
  type    = list(string)
  default = null
}

variable "host_labels" {
  type    = list(string)
  default = ["env:dev"]

  validation {
    condition     = can([for s in var.host_labels : regex("^[a-zA-Z0-9:]+$", s)])
    error_message = "Label must be of the form `key:value`."
  }
}

variable "location_bucket" {
  type    = string
  default = null
}

variable "host_provider" {
  type    = string
  default = "ibm"
}