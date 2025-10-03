output "management_group_ids" {
  description = "Map of management group names to their IDs"
  value = {
    ti             = azurerm_management_group.ti.id
    infra          = azurerm_management_group.infra.id
    management     = azurerm_management_group.management.id
    policy_staging = azurerm_management_group.policy_staging.id
    workload       = azurerm_management_group.workload.id
    sandbox        = azurerm_management_group.sandbox.id
  }
}

output "root_management_group_id" {
  description = "ID of the TI management group (top-level custom management group)"
  value       = azurerm_management_group.ti.id
}

output "ti_management_group_id" {
  description = "ID of the TI management group"
  value       = azurerm_management_group.ti.id
}
