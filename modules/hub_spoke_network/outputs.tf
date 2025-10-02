output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.network.id
}

output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.hub.name
}

output "spoke_vnet_id" {
  description = "ID of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.name
}

output "gateway_subnet_id" {
  description = "ID of the Gateway Subnet"
  value       = azurerm_subnet.gateway.id
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.hub.id
}

output "vpn_gateway_public_ip" {
  description = "Public IP of the VPN Gateway"
  value       = azurerm_public_ip.vpn_gateway.ip_address
}

output "peering_hub_to_spoke_id" {
  description = "ID of the peering from hub to spoke"
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
}

output "peering_spoke_to_hub_id" {
  description = "ID of the peering from spoke to hub"
  value       = azurerm_virtual_network_peering.spoke_to_hub.id
}
