resource "ibm_is_instance" "satellite_cp_vsi" {
  count          = var.host_count
  name           = "${var.project_name}-${var.environment}-cp-vsi-${count.index}"
  vpc            = ibm_is_vpc.satellite_vpc.id
  zone           = element(var.location_zones, count.index)
  image          = data.ibm_is_image.rhel7.id
  profile        = var.host_profile
  keys           = [ibm_is_ssh_key.satellite_ssh.id]
  resource_group = data.ibm_resource_group.group.id
  user_data      = module.satellite-location.host_script

  primary_network_interface {
    subnet = element(local.subnet_ids, count.index)
  }
  depends_on     = [module.satellite-location]
}

resource "ibm_is_floating_ip" "satellite_ip_cp" {
  count  = var.host_count
  name   = "${var.project_name}-${var.environment}-cp-fip-${count.index}"
  target = ibm_is_instance.satellite_cp_vsi[count.index].primary_network_interface[0].id
}

resource "ibm_is_instance" "satellite_cluster_vsi" {
  count          = var.cluster_host_count
  name           = "${var.project_name}-${var.environment}-ocp-vsi-${count.index}"
  vpc            = ibm_is_vpc.satellite_vpc.id
  zone           = element(var.cluster_zones, count.index)
  image          = data.ibm_is_image.rhel7.id
  profile        = var.cluster_host_profile
  keys           = [ibm_is_ssh_key.satellite_ssh.id]
  resource_group = data.ibm_resource_group.group.id
  user_data      = module.satellite-location.host_script
  primary_network_interface {
    subnet = element(local.subnet_ids, count.index)
  }
  depends_on     = [module.satellite-location]
}

resource "ibm_is_floating_ip" "satellite_ip_cluster" {
  count  = var.cluster_host_count
  name   = "${var.project_name}-${var.environment}-ocp-fip-${count.index}"
  target = ibm_is_instance.satellite_cluster_vsi[count.index].primary_network_interface[0].id
}