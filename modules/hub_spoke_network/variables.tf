variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for networking resources"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  type        = string
}

variable "hub_vnet_address_space" {
  description = "Address space for hub VNet"
  type        = list(string)
}

variable "spoke_vnet_address_space" {
  description = "Address space for spoke VNet"
  type        = list(string)
}

variable "gateway_subnet_address_prefix" {
  description = "Address prefix for Gateway Subnet"
  type        = string
}

variable "vpn_gateway_sku" {
  description = "SKU of the VPN Gateway"
  type        = string
}
