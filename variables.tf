variable "root_management_group_name" {
  description = "Name of the root management group"
  type        = string
  default     = "TI"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "southcentralus"
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
  default     = "hub-vnet"
}

variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  type        = string
  default     = "spoke-vnet"
}

variable "hub_vnet_address_space" {
  description = "Address space for hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_vnet_address_space" {
  description = "Address space for spoke VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "gateway_subnet_address_prefix" {
  description = "Address prefix for Gateway Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "resource_group_name" {
  description = "Name of the resource group for networking resources"
  type        = string
  default     = "rg-hub-spoke-network"
}

variable "vpn_gateway_sku" {
  description = "SKU of the VPN Gateway"
  type        = string
  default     = "VpnGw1"
}

variable "local_network_gateway_name" {
  description = "Name of the local network gateway"
  type        = string
  default     = "lng-onprem"
}

variable "local_network_gateway_address" {
  description = "Public IP address of the on-premises VPN device"
  type        = string
}

variable "local_network_address_space" {
  description = "Address space of the on-premises network"
  type        = list(string)
}

variable "vpn_connection_name" {
  description = "Name of the VPN connection"
  type        = string
  default     = "conn-hub-to-onprem"
}

variable "vpn_shared_key" {
  description = "Shared key for the VPN connection"
  type        = string
  sensitive   = true
}
