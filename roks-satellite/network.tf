resource "ibm_is_vpc" "satellite_vpc" {
  name                     = "${var.project_name}-${var.environment}-vpc"
}

resource "ibm_is_subnet" "satellite_subnet" {
  count                    = 3

  name                     = "${var.project_name}-${var.environment}-subnet-${count.index}"
  vpc        = ibm_is_vpc.satellite_vpc.id
  total_ipv4_address_count = 256
  zone                     = "${var.ibm_region}-${count.index + 1}"
}

resource ibm_is_security_group "sg" {
  name                     = "${var.project_name}-${var.environment}-sg"
  vpc                      = ibm_is_vpc.satellite_vpc.id
}

resource "tls_private_key" "key" {
  algorithm                = "RSA"
  rsa_bits                 = 4096
}

resource "ibm_is_ssh_key" "satellite_ssh" {
  depends_on               = [module.satellite-location]

  name                     = "${var.project_name}-${var.environment}-ssh"
  public_key               = var.public_key != null ? var.public_key : tls_private_key.key.public_key_openssh
}

locals {
  zones                    = ["${var.ibm_region}-1", "${var.ibm_region}-2", "${var.ibm_region}-3"]
  subnet_ids               = [ibm_is_subnet.satellite_subnet[0].id, ibm_is_subnet.satellite_subnet[1].id, ibm_is_subnet.satellite_subnet[2].id]
}