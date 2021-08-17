resource "ibm_is_vpc" "satellite_vpc" {
  name                      = "${var.project_name}-${var.environment}-vpc"
  resource_group            = data.ibm_resource_group.group.id
  address_prefix_management = "manual"
}

resource "ibm_is_vpc_address_prefix" "vpc_address_prefix" {
  count = local.max_size
  name  = "${var.project_name}-${var.environment}-range-${format("%02s", count.index)}"
  zone  = var.cluster_zones[count.index]
  vpc   = ibm_is_vpc.satellite_vpc.id
  cidr  = var.enable_custom_address_prefix ? var.address_prefix_cidr[count.index] : "10.0.${format("%01s", count.index)}.0/24"
}

resource "ibm_is_subnet" "satellite_subnet" {
  count           = local.max_size
  depends_on      = [ibm_is_vpc_address_prefix.vpc_address_prefix]
  name            = "${var.project_name}-${var.environment}-subnet-${format("%02s", count.index)}"
  zone            = var.cluster_zones[count.index]
  vpc             = ibm_is_vpc.satellite_vpc.id
  public_gateway  = var.enable_public_gateway ? ibm_is_public_gateway.iac_iks_gateway[count.index].id : ""
  ipv4_cidr_block = var.enable_custom_subnet ? var.subnet_cidr[count.index] : "10.0.${format("%01s", count.index)}.0/26"
  resource_group  = data.ibm_resource_group.group.id
}

resource "ibm_is_public_gateway" "iac_iks_gateway" {
  count          = var.enable_public_gateway ? local.max_size : 0
  name           = "${var.project_name}-${var.environment}-gateway-${format("%02s", count.index)}"
  vpc            = ibm_is_vpc.satellite_vpc.id
  zone           = var.cluster_zones[count.index]
  resource_group = data.ibm_resource_group.group.id

  timeouts {
    create = "90m"
  }
}

resource "ibm_security_group" "sg" {
  count = local.max_size
  name  = "${var.project_name}-${var.environment}-sg-${format("%02s", count.index)}"
  description = "Allow ingress traffic"
}

resource "ibm_is_security_group_rule" "iac_iks_security_group_rule_tcp_k8s" {
  count             = local.max_size
  group             = ibm_is_vpc.satellite_vpc.resource_group
  direction         = "ingress"
  port_range_min    = 30000
  port_range_max    = 32767
  protocol          = "tcp"
  security_group_id = ibm_security_group.sg.id
  remote_ip         = ibm_is_subnet.satellite_subnet[count.index].ipv4_cidr_block
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "satellite_ssh" {
  depends_on     = [module.satellite-location]
  name           = "${var.project_name}-${var.environment}-ssh"
  public_key     = var.public_key != null ? var.public_key : tls_private_key.key.public_key_openssh
  resource_group = data.ibm_resource_group.group.id
}

locals {
  subnet_ids = [ibm_is_subnet.satellite_subnet[0].id, ibm_is_subnet.satellite_subnet[1].id, ibm_is_subnet.satellite_subnet[2].id]
}