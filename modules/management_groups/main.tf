# Management Group Hierarchy
# Root MG
#   └── TI
#       ├── Infra
#       ├── Management
#       ├── PolicyStaging
#       ├── Workload
#       └── Sandbox

# Get the tenant root group
data "azurerm_client_config" "current" {}

# Get the tenant root management group
data "azurerm_management_group" "tenant_root" {
  name = data.azurerm_client_config.current.tenant_id
}

# TI Management Group (using tenant root as parent)
resource "azurerm_management_group" "ti" {
  name                       = var.root_management_group_name
  display_name               = var.root_management_group_name
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Infra Management Group
resource "azurerm_management_group" "infra" {
  name                       = "Infra"
  display_name               = "Infra"
  parent_management_group_id = azurerm_management_group.ti.id
}

# Management Management Group
resource "azurerm_management_group" "management" {
  name                       = "Management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.ti.id
}

# PolicyStaging Management Group
resource "azurerm_management_group" "policy_staging" {
  name                       = "PolicyStaging"
  display_name               = "PolicyStaging"
  parent_management_group_id = azurerm_management_group.ti.id
}

# Workload Management Group
resource "azurerm_management_group" "workload" {
  name                       = "Workload"
  display_name               = "Workload"
  parent_management_group_id = azurerm_management_group.ti.id
}

# Sandbox Management Group
resource "azurerm_management_group" "sandbox" {
  name                       = "Sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.ti.id
}
