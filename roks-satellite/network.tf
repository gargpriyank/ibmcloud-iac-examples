resource "ibm_is_vpc" "satellite_vpc" {
  name                      = "${var.project_name}-${var.environment}-vpc"
  resource_group            = data.ibm_resource_group.group.id
  address_prefix_management = "manual"
}

resource "ibm_is_vpc_address_prefix" "vpc_address_prefix" {
  count = local.max_size
  name  = "${var.project_name}-${var.environment}-range-${format("%02s", count.index)}"
  zone  = var.location_zones[count.index]
  vpc   = ibm_is_vpc.satellite_vpc.id
  cidr  = var.enable_custom_address_prefix ? var.address_prefix_cidr[count.index] : "10.0.${format("%01s", count.index)}.0/24"
}

resource "ibm_is_subnet" "satellite_subnet" {
  count           = local.max_size
  name            = "${var.project_name}-${var.environment}-subnet-${format("%02s", count.index)}"
  zone            = var.location_zones[count.index]
  vpc             = ibm_is_vpc.satellite_vpc.id
  ipv4_cidr_block = var.enable_custom_subnet ? var.subnet_cidr[count.index] : "10.0.${format("%01s", count.index)}.0/26"
  resource_group  = data.ibm_resource_group.group.id
  depends_on      = [ibm_is_vpc_address_prefix.vpc_address_prefix]
}

resource "ibm_is_security_group_rule" "iac_iks_security_group_rule_all" {
  count     = var.cluster_enable_public_access ? 1 : 0
  group     = ibm_is_vpc.satellite_vpc.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "iac_iks_security_group_rule_tcp_ocp" {
  count     = var.cluster_enable_public_access ? 0 : local.max_size
  group     = ibm_is_vpc.satellite_vpc.default_security_group
  direction = "inbound"
  remote    = ibm_is_subnet.satellite_subnet[count.index].ipv4_cidr_block

  tcp {
    port_min = 30000
    port_max = 32767
  }
}

resource "ibm_is_security_group_rule" "iac_iks_security_group_rule_tcp_https" {
  count     = var.cluster_enable_public_access ? 0 : local.max_size
  group     = ibm_is_vpc.satellite_vpc.default_security_group
  direction = "inbound"
  remote    = ibm_is_subnet.satellite_subnet[count.index].ipv4_cidr_block

  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "satellite_ssh" {
  name           = "${var.project_name}-${var.environment}-ssh"
  public_key     = var.public_key != null ? var.public_key : tls_private_key.key.public_key_openssh
  resource_group = data.ibm_resource_group.group.id
  depends_on     = [module.satellite-location]
}

locals {
  subnet_ids = ibm_is_subnet.satellite_subnet[*].id
}