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
  default = ["us-east-1", "us-east-2", "us-east-3"]
}

variable "managed_from" {
  type    = string
  default = "wdc"
}

variable "location_zones" {
  type    = list(string)
  default = ["us-east-1", "us-east-2", "us-east-3"]
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
  default = ["env:poc"]

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