output "management_group_ids" {
  description = "IDs of the created management groups"
  value       = module.management_groups.management_group_ids
}

output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = module.hub_spoke_network.hub_vnet_id
}

output "spoke_vnet_id" {
  description = "ID of the spoke virtual network"
  value       = module.hub_spoke_network.spoke_vnet_id
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = module.hub_spoke_network.vpn_gateway_id
}

output "peering_hub_to_spoke_id" {
  description = "ID of the peering from hub to spoke"
  value       = module.hub_spoke_network.peering_hub_to_spoke_id
}

output "peering_spoke_to_hub_id" {
  description = "ID of the peering from spoke to hub"
  value       = module.hub_spoke_network.peering_spoke_to_hub_id
}
