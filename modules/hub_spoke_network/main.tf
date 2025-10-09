# Resource Group for Networking Resources
resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
}

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.hub_vnet_address_space
}

# Gateway Subnet in Hub VNet
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_address_prefix]
}

# Azure Bastion Subnet (for secure access)
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.bastion_subnet_address_prefix]
}

# Azure Firewall Subnet (for egress filtering)
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_address_prefix]
}

# DNS Private Resolver Inbound Subnet
resource "azurerm_subnet" "dns_resolver_inbound" {
  name                 = "snet-dns-resolver-inbound"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.dns_resolver_inbound_subnet_prefix]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

# DNS Private Resolver Outbound Subnet
resource "azurerm_subnet" "dns_resolver_outbound" {
  name                 = "snet-dns-resolver-outbound"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.dns_resolver_outbound_subnet_prefix]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

# Public IP for VPN Gateway
resource "azurerm_public_ip" "vpn_gateway" {
  name                = "pip-${var.hub_vnet_name}-vpn-gw"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Virtual Network Gateway (VPN Gateway)
resource "azurerm_virtual_network_gateway" "hub" {
  name                = "vng-${var.hub_vnet_name}"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.vpn_gateway_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
}

# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.spoke_vnet_address_space
}

# VNet Peering: Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# VNet Peering: Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true

  depends_on = [azurerm_virtual_network_gateway.hub]
}

# Local Network Gateway (represents on-premises network)
resource "azurerm_local_network_gateway" "onprem" {
  name                = var.local_network_gateway_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  gateway_address     = var.local_network_gateway_address
  address_space       = var.local_network_address_space
}

# Azure Private DNS Zones for AI services (centralized in hub)
# Azure AI Foundry services
resource "azurerm_private_dns_zone" "ai_foundry" {
  name                = "privatelink.services.ai.azure.com"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone" "openai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone" "cognitive_services" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.network.name
}

# Foundry Agent Service dependencies
resource "azurerm_private_dns_zone" "search" {
  name                = "privatelink.search.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone" "cosmosdb" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.network.name
}

# Additional common services
resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone" "webapp" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.network.name
}

# DNS Private Resolver
resource "azurerm_private_dns_resolver" "hub" {
  name                = "dnspr-${var.hub_vnet_name}"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  virtual_network_id  = azurerm_virtual_network.hub.id
}

# DNS Private Resolver Inbound Endpoint
resource "azurerm_private_dns_resolver_inbound_endpoint" "hub" {
  name                    = "dnspr-in-${var.hub_vnet_name}"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub.id
  location                = azurerm_resource_group.network.location
  
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_resolver_inbound.id
  }
}

# DNS Private Resolver Outbound Endpoint
resource "azurerm_private_dns_resolver_outbound_endpoint" "hub" {
  name                    = "dnspr-out-${var.hub_vnet_name}"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub.id
  location                = azurerm_resource_group.network.location
  subnet_id               = azurerm_subnet.dns_resolver_outbound.id
}

# DNS Forwarding Ruleset for on-premises DNS
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "hub" {
  name                                       = "dnsrs-${var.hub_vnet_name}"
  resource_group_name                        = azurerm_resource_group.network.name
  location                                   = azurerm_resource_group.network.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.hub.id]
}

# Link Private DNS Zones to Hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "ai_foundry_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.ai_foundry.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cognitive_services_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.cognitive_services.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "search_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.search.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webapp_hub" {
  name                  = "link-${var.hub_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.webapp.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

# Link Private DNS Zones to Spoke VNet (for AI landing zone)
resource "azurerm_private_dns_zone_virtual_network_link" "ai_foundry_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.ai_foundry.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cognitive_services_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.cognitive_services.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "search_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.search.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webapp_spoke" {
  name                  = "link-${var.spoke_vnet_name}"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.webapp.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

# VPN Connection between Virtual Network Gateway and Local Network Gateway
# Temporarily commented out to resolve deployment issues
# resource "azurerm_virtual_network_gateway_connection" "hub_to_onprem" {
#   name                = var.vpn_connection_name
#   location            = azurerm_resource_group.network.location
#   resource_group_name = azurerm_resource_group.network.name
#
#   type                       = "IPsec"
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.hub.id
#   local_network_gateway_id   = azurerm_local_network_gateway.onprem.id
#
#   shared_key = var.vpn_shared_key
#
#   # Explicit dependencies to ensure proper creation order
#   depends_on = [
#     azurerm_virtual_network_gateway.hub,
#     azurerm_local_network_gateway.onprem,
#     azurerm_public_ip.vpn_gateway,
#     azurerm_subnet.gateway
#   ]
# }
