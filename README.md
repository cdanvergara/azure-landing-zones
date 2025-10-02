# azure-landing-zones
Template to create a brand new structure of management groups aligned with ALZ design

This Terraform template creates a complete Azure Landing Zone infrastructure with two main modules:

## Module 1: Management Groups

Creates a hierarchical management group structure:

```
Root
└── TI
    ├── Infra
    ├── Management
    ├── PolicyStaging
    ├── Workload
    └── Sandbox
```

## Module 2: Hub and Spoke Network

Creates a hub-and-spoke network architecture with:
- Hub Virtual Network with Gateway Subnet
- Virtual Network Gateway (VPN Gateway)
- Spoke Virtual Network
- VNet Peering between Hub and Spoke

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- Azure CLI authenticated with appropriate permissions
- Azure subscription with necessary permissions to create management groups and networking resources

## Usage

1. Clone this repository:
```bash
git clone https://github.com/cdanvergara/azure-landing-zones.git
cd azure-landing-zones
```

2. Copy the example variables file and customize it:
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your desired values
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the planned changes:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

## Configuration Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `root_management_group_name` | Name of the root management group | `Root` |
| `location` | Azure region for resources | `eastus` |
| `resource_group_name` | Name of the resource group for networking resources | `rg-hub-spoke-network` |
| `hub_vnet_name` | Name of the hub virtual network | `hub-vnet` |
| `spoke_vnet_name` | Name of the spoke virtual network | `spoke-vnet` |
| `hub_vnet_address_space` | Address space for hub VNet | `["10.0.0.0/16"]` |
| `spoke_vnet_address_space` | Address space for spoke VNet | `["10.1.0.0/16"]` |
| `gateway_subnet_address_prefix` | Address prefix for Gateway Subnet | `10.0.1.0/24` |
| `vpn_gateway_sku` | SKU of the VPN Gateway | `VpnGw1` |

## Outputs

The template provides the following outputs:
- Management group IDs
- Hub and Spoke VNet IDs
- VPN Gateway ID
- Peering connection IDs

## Architecture

### Management Groups Module
Located in `modules/management_groups/`, this module creates a hierarchical structure for organizing Azure subscriptions and applying policies at scale.

### Hub and Spoke Network Module
Located in `modules/hub_spoke_network/`, this module implements a hub-and-spoke network topology, which is a best practice for Azure networking. The hub contains shared services like the VPN Gateway, while spokes contain workload-specific resources.

## Cleanup

To destroy all resources created by this template:

```bash
terraform destroy
```

**Note:** Management groups may have dependencies and require subscriptions to be moved before deletion.

## License

This project is provided as-is for use with Azure Landing Zones.
