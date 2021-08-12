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
  default = "wdc"
}

variable "location_zones" {
  type    = list(string)
  default = null
}

variable "host_labels" {
  type    = list(string)
  default = ["env:dev"]
}

variable "location_bucket" {
  type    = string
  default = null
}

variable "host_provider" {
  type    = string
  default = "ibm"
}