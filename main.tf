# Module 1: Management Groups
module "management_groups" {
  source = "./modules/management_groups"

  root_management_group_name = var.root_management_group_name
}

# Module 2: Hub and Spoke Network
module "hub_spoke_network" {
  source = "./modules/hub_spoke_network"

  location                      = var.location
  resource_group_name           = var.resource_group_name
  hub_vnet_name                 = var.hub_vnet_name
  spoke_vnet_name               = var.spoke_vnet_name
  hub_vnet_address_space        = var.hub_vnet_address_space
  spoke_vnet_address_space      = var.spoke_vnet_address_space
  gateway_subnet_address_prefix = var.gateway_subnet_address_prefix
  vpn_gateway_sku               = var.vpn_gateway_sku
  local_network_gateway_name    = var.local_network_gateway_name
  local_network_gateway_address = var.local_network_gateway_address
  local_network_address_space   = var.local_network_address_space
  vpn_connection_name           = var.vpn_connection_name
  vpn_shared_key                = var.vpn_shared_key
}
