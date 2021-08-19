data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_satellite_cluster" "cluster" {
  name  = var.cluster_name
  depends_on = [ibm_satellite_cluster.create_cluster]
}