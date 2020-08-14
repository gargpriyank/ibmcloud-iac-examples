resource "ibm_is_vpn_gateway" "iac_vpn_gateway" {
  count          = local.max_size
  name           = "${var.project_name}-${var.environment}-vpn-gateway-${format("%02s", count.index)}"
  subnet         = ibm_is_subnet.iac_iks_subnet[count.index].id
  resource_group = data.ibm_resource_group.group.id
  depends_on     = [ibm_is_subnet.iac_iks_subnet]
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection" {
  count          = local.max_size
  name           = "${var.project_name}-${var.environment}-vpn-connection-${format("%02s", count.index)}"
  vpn_gateway    = ibm_is_vpn_gateway.iac_vpn_gateway[count.index].id
  peer_address   = var.vpn_peer_public_address[count.index]
  preshared_key  = var.vpn_connection_pre_shared_key[count.index]
  local_cidrs    = [ibm_is_subnet.iac_iks_subnet[count.index].ipv4_cidr_block]
  peer_cidrs     = [var.vpn_peer_cidr[count.index]]
  interval       = var.vpn_connection_interval[count.index]
  timeout        = var.vpn_connection_timeout[count.index]
  admin_state_up = var.vpn_connection_admin_state_up[count.index]
  action         = var.vpn_connection_action[count.index]
  depends_on    = [ibm_is_vpn_gateway.iac_vpn_gateway]
}
