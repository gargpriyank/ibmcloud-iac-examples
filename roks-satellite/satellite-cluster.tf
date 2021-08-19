module "satellite-cluster" {
  source                      = "./modules/satellite-cluster"
  cluster_name                = var.cluster_name
  location                    = module.satellite-location.location_id
  cluster_enable_config_admin = var.cluster_enable_config_admin
  ocp_version                 = var.ocp_version
  cluster_zones               = var.cluster_zones
  resource_group              = var.resource_group
  depends_on                  = [module.satellite-hosts]
}