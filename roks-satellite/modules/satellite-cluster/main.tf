resource "ibm_satellite_cluster" "create_cluster" {
  name                       = var.cluster_name
  location                   = var.location
  enable_config_admin        = var.cluster_enable_config_admin
  kube_version               = var.ocp_version
  resource_group_id          = data.ibm_resource_group.group.id
  wait_for_worker_update     = true
  dynamic "zones" {
    for_each = var.cluster_zones
    content {
      id  = zones.value
    }
  }
}