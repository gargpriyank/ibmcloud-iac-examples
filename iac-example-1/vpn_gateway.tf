resource "ibm_is_vpn_gateway" "iac_vpn_gateway" {
  count          = local.max_size
  name           = var.vpn_gateway_name
  subnet         = ibm_is_subnet.iac_iks_subnet[count.index].id
  resource_group = data.ibm_resource_group.group.id
  depends_on     = [ibm_is_subnet.iac_iks_subnet]
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection" {
  count          = local.max_size
  name           = var.vpn_connection_name
  vpn_gateway    = ibm_is_vpn_gateway.iac_vpn_gateway[count.index].id
  peer_address   = var.vpn_peer_public_address
  preshared_key  = var.vpn_connection_pre_shared_key
  local_cidrs    = [ibm_is_subnet.iac_iks_subnet[count.index].ipv4_cidr_block]
  peer_cidrs     = var.vpn_peer_cidr
  interval       = var.vpn_connection_interval
  timeout        = var.vpn_connection_timeout
  admin_state_up = var.vpn_connection_admin_state_up
  action         = var.vpn_connection_action
  depends_on    = [ibm_is_vpn_gateway.iac_vpn_gateway]
}
