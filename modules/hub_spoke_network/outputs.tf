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

output "local_network_gateway_id" {
  description = "ID of the local network gateway"
  value       = azurerm_local_network_gateway.onprem.id
}

# Temporarily commented out to resolve deployment issues
# output "vpn_connection_id" {
#   description = "ID of the VPN connection"
#   value       = azurerm_virtual_network_gateway_connection.hub_to_onprem.id
# }

output "bastion_subnet_id" {
  description = "ID of the Azure Bastion subnet"
  value       = azurerm_subnet.bastion.id
}

output "firewall_subnet_id" {
  description = "ID of the Azure Firewall subnet"
  value       = azurerm_subnet.firewall.id
}

output "dns_private_resolver_id" {
  description = "ID of the DNS Private Resolver"
  value       = azurerm_private_dns_resolver.hub.id
}

output "dns_private_resolver_inbound_endpoint_ip" {
  description = "IP address of the DNS Private Resolver inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.hub.ip_configurations[0].private_ip_address
}

output "private_dns_zones" {
  description = "Map of private DNS zone names to their IDs"
  value = {
    ai_foundry         = azurerm_private_dns_zone.ai_foundry.id
    openai             = azurerm_private_dns_zone.openai.id
    cognitive_services = azurerm_private_dns_zone.cognitive_services.id
    search             = azurerm_private_dns_zone.search.id
    blob               = azurerm_private_dns_zone.blob.id
    cosmosdb           = azurerm_private_dns_zone.cosmosdb.id
    keyvault           = azurerm_private_dns_zone.keyvault.id
    webapp             = azurerm_private_dns_zone.webapp.id
  }
}
