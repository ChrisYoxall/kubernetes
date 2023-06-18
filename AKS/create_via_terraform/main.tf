resource "azurerm_resource_group" "rg" {
  name     = "${var.aks_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.aks_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.aks_name}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  node_resource_group = "${var.aks_name}-node-rg"
  dns_prefix          = var.aks_name

  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    vnet_subnet_id      = azurerm_subnet.subnet.id
  }

  # network_profile {
  #   network_plugin    = "azure"
  #   network_policy    = "calico"
  #   load_balancer_sku = "standard"
  # }

  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_kubernetes_cluster_node_pool" "user" {
#   name                  = "user"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
#   vm_size               = var.vm_size
#   node_count            = 1
#   vnet_subnet_id        = azurerm_subnet.subnet.id
# }