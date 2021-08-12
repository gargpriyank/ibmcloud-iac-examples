variable "location" {
  type    = string
}

variable "location_zones" {
  type    = list(string)
  default = null
}

variable "host_labels" {
  type    = list(string)
  default = null

  validation {
    condition     = can([for s in var.host_labels : regex("^[a-zA-Z0-9:]+$", s)])
    error_message = "Label must be of the form `key:value`."
  }
}

variable "host_vms" {
  type    = list(string)
  default = []
}

variable "host_count" {
  type    = number
  default = 3

}

variable "host_provider" {
  type    = string
  default = "ibm"
}