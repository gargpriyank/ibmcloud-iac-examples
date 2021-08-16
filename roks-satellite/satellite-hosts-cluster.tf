resource "ibm_satellite_cluster" "create_cluster" {
  depends_on = [module.satellite-hosts-cp]
  name                   = var.cluster_name
  location               = var.location
  enable_config_admin    = var.cluster_enable_config_admin
  kube_version           = var.ocp_version
  resource_group_id      = data.ibm_resource_group.group.id
  wait_for_worker_update = true
  dynamic "zones" {
    for_each = var.cluster_zones
    content {
      id  = zones.value
    }
  }
}

resource "ibm_satellite_host" "assign_host" {
  count         = var.cluster_host_count
  depends_on    = [ibm_satellite_cluster.create_cluster]
  location      = var.location
  cluster       = ibm_satellite_cluster.create_cluster.id
  host_id       = element(ibm_is_instance.satellite_cluster_vsi[*].name, count.index)
  labels        = var.host_labels
  zone          = var.location_zones != null ? element(var.location_zones, count.index) : null
  host_provider = var.host_provider
}