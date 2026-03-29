terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "aks" {
  name                = "${var.cluster_name}-vnet"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# AKS Subnet
resource "azurerm_subnet" "aks" {
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.subnet_address_prefixes
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_node_count : null
    max_count           = var.enable_auto_scaling ? var.max_node_count : null
    max_pods            = var.max_pods
    os_disk_size_gb     = var.os_disk_size_gb
    type                = "VirtualMachineScaleSets"
    
    # Node labels
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
    }
    
    # Node taints (optional)
    # node_taints = ["CriticalAddonsOnly=true:NoSchedule"]
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = "standard"
    network_policy    = var.network_policy
    outbound_type     = "loadBalancer"
  }

  # Enable RBAC
  role_based_access_control_enabled = true

  # Add tags
  tags = var.tags

  # Optional: Enable container monitoring
  # oms_agent {
  #   log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  # }
}

# Optional: Additional node pool
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  count = var.enable_user_node_pool ? 1 : 0

  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_node_pool_vm_size
  node_count            = var.user_node_pool_node_count
  enable_auto_scaling   = var.user_node_pool_auto_scaling
  min_count             = var.user_node_pool_auto_scaling ? var.user_node_pool_min_count : null
  max_count             = var.user_node_pool_auto_scaling ? var.user_node_pool_max_count : null
  max_pods              = var.max_pods
  os_disk_size_gb       = var.os_disk_size_gb
  vnet_subnet_id        = azurerm_subnet.aks.id
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
  }
  tags = var.tags
}