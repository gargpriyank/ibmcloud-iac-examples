data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_is_image" "rhel7" {
  name = "ibm-redhat-7-9-minimal-amd64-3"
}