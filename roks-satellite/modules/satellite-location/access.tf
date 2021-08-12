data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_satellite_location" "location" {
  location   = var.location
  depends_on = [ibm_satellite_location.create_location]
}

data "ibm_satellite_attach_host_script" "script" {
  location      = data.ibm_satellite_location.location.id
  labels        = var.host_labels
  host_provider = var.host_provider
}