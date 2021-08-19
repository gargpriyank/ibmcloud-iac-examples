resource "ibm_satellite_host" "assign_host" {
  count         = var.cluster_host_count
  location      = var.location
  cluster       = module.satellite-cluster.cluster_id
  host_id       = element(ibm_is_instance.satellite_cluster_vsi[*].name, count.index)
  labels        = var.host_labels
  zone          = var.location_zones != null ? element(var.location_zones, count.index) : null
  host_provider = var.host_provider
  depends_on    = [module.satellite-cluster]
}