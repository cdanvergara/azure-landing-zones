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

output "vpn_gateway_public_ip" {
  description = "Public IP of the VPN Gateway"
  value       = module.hub_spoke_network.vpn_gateway_public_ip
}

output "local_network_gateway_id" {
  description = "ID of the local network gateway"
  value       = module.hub_spoke_network.local_network_gateway_id
}

# Temporarily commented out to resolve deployment issues
# output "vpn_connection_id" {
#   description = "ID of the VPN connection"
#   value       = module.hub_spoke_network.vpn_connection_id
# }

output "dns_private_resolver_id" {
  description = "ID of the DNS Private Resolver in hub"
  value       = module.hub_spoke_network.dns_private_resolver_id
}

output "dns_resolver_inbound_ip" {
  description = "IP address of the DNS Private Resolver inbound endpoint"
  value       = module.hub_spoke_network.dns_private_resolver_inbound_endpoint_ip
}

output "private_dns_zones" {
  description = "Map of private DNS zone names to their IDs"
  value       = module.hub_spoke_network.private_dns_zones
}

output "bastion_subnet_id" {
  description = "ID of the Azure Bastion subnet"
  value       = module.hub_spoke_network.bastion_subnet_id
}

output "firewall_subnet_id" {
  description = "ID of the Azure Firewall subnet"
  value       = module.hub_spoke_network.firewall_subnet_id
}
