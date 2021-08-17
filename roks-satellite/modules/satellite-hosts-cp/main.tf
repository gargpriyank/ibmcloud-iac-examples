resource "ibm_satellite_host" "assign_host" {
  count = var.host_count
  location      = var.location
  host_id       = var.host_vms != null ? element(var.host_vms, count.index) : null
  labels        = var.host_labels
  zone          = var.location_zones != null ? element(var.location_zones, count.index) : null
  host_provider = var.host_provider
}