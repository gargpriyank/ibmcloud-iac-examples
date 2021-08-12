module "satellite-hosts-cp" {
  source         = "./modules/satellite-hosts-cp"
  host_count     = var.host_count
  location       = module.satellite-location.location_id
  host_vms       = ibm_is_instance.satellite_cp_vsi[*].name
  location_zones = var.location_zones
  host_labels    = var.host_labels
  host_provider  = var.host_provider
}