variable "location" {
  type    = string
}

variable "location_zones" {
  type    = list(string)
  default = null
}

variable "host_labels" {
  type    = list(string)
  default = ["env:dev"]
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