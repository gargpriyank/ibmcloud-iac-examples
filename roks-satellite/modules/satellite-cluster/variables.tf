variable "cluster_name" {
  type    = string
  default = null
}

variable "location" {
  type    = string
}

variable "cluster_enable_config_admin" {
  type    = bool
  default = true
}

variable "ocp_version" {
  type    = string
  default = "4.7_openshift"
}

variable "resource_group" {
  type    = string
}

variable "cluster_zones" {
  type    = list(string)
  default = ["us-south-1", "us-south-2", "us-south-3"]
}