# Basic Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastasia"
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix"
  type        = string
}

# Node Pool Configuration
variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Virtual machine size for nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the node pool"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}

# Network Configuration
variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = ["172.16.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes"
  type        = list(string)
  default     = ["172.16.1.0/24"]
}

variable "network_plugin" {
  description = "Network plugin (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy (azure or calico)"
  type        = string
  default     = null
}

variable "max_pods" {
  description = "Maximum number of pods per node"
  type        = number
  default     = 30
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 30
}

# User Node Pool Configuration
variable "enable_user_node_pool" {
  description = "Enable user node pool"
  type        = bool
  default     = false
}

variable "user_node_pool_vm_size" {
  description = "User node pool VM size"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "user_node_pool_node_count" {
  description = "User node pool node count"
  type        = number
  default     = 2
}

variable "user_node_pool_auto_scaling" {
  description = "Enable auto-scaling for user node pool"
  type        = bool
  default     = false
}

variable "user_node_pool_min_count" {
  description = "User node pool minimum node count"
  type        = number
  default     = 1
}

variable "user_node_pool_max_count" {
  description = "User node pool maximum node count"
  type        = number
  default     = 5
}

# Tags
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}