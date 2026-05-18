# PCAM Networking Module - Main Configuration
# File: PCAM/networking.tf
# Description: Complete networking infrastructure definition

# Virtual Network (VNet)
resource "azurerm_virtual_network" "pcam_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  dynamic "dns_servers" {
    for_each = length(var.dns_servers) > 0 ? [1] : []
    content {
      servers = var.dns_servers
    }
  }

  tags = merge(
    var.tags,
    {
      Name        = var.vnet_name
      Environment = var.environment
    }
  )
}

# Application Subnet
resource "azurerm_subnet" "app_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.pcam_vnet.name
  address_prefixes     = [var.subnet_address_prefix]

  service_endpoints = var.service_endpoints
}

# AKS Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.pcam_vnet.name
  address_prefixes     = [var.aks_subnet_address_prefix]

  service_endpoints = var.service_endpoints
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "pcam_nsg" {
  count               = var.create_nsg ? 1 : 0
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      Name = var.nsg_name
    }
  )
}

# NSG Rules
resource "azurerm_network_security_rule" "nsg_rules" {
  count                       = var.create_nsg ? length(var.nsg_rules) : 0
  name                        = var.nsg_rules[count.index].name
  priority                    = var.nsg_rules[count.index].priority
  direction                   = var.nsg_rules[count.index].direction
  access                      = var.nsg_rules[count.index].access
  protocol                    = var.nsg_rules[count.index].protocol
  source_port_range           = var.nsg_rules[count.index].source_port_range
  destination_port_range      = var.nsg_rules[count.index].destination_port_range
  source_address_prefix       = var.nsg_rules[count.index].source_address_prefix
  destination_address_prefix  = var.nsg_rules[count.index].destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.pcam_nsg[0].name
}

# NSG Association with Application Subnet
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg" {
  count                     = var.create_nsg ? 1 : 0
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.pcam_nsg[0].id
}

# NSG Association with AKS Subnet
resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg" {
  count                     = var.create_nsg ? 1 : 0
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.pcam_nsg[0].id
}

# Route Table
resource "azurerm_route_table" "pcam_route_table" {
  count               = var.create_route_table ? 1 : 0
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      Name = var.route_table_name
    }
  )
}

# Routes
resource "azurerm_route" "pcam_routes" {
  count                  = var.create_route_table ? length(var.routes) : 0
  name                   = var.routes[count.index].name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.pcam_route_table[0].name
  address_prefix         = var.routes[count.index].address_prefix
  next_hop_type          = var.routes[count.index].next_hop_type
  next_hop_in_ip_address = try(var.routes[count.index].next_hop_in_ip_address, null)
}

# Route Table Association with Application Subnet
resource "azurerm_subnet_route_table_association" "app_subnet_rt" {
  count          = var.create_route_table ? 1 : 0
  subnet_id      = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.pcam_route_table[0].id
}

# Route Table Association with AKS Subnet
resource "azurerm_subnet_route_table_association" "aks_subnet_rt" {
  count          = var.create_route_table ? 1 : 0
  subnet_id      = azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.pcam_route_table[0].id
}

# Public IP
resource "azurerm_public_ip" "pcam_public_ip" {
  count               = var.create_public_ip ? 1 : 0
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku

  tags = merge(
    var.tags,
    {
      Name = var.public_ip_name
    }
  )
}

# Network Interface
resource "azurerm_network_interface" "pcam_nic" {
  count               = var.create_nic ? 1 : 0
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = var.nic_ip_address_allocation
    private_ip_address            = var.nic_ip_address_allocation == "Static" ? var.private_ip_address : null
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.pcam_public_ip[0].id : null
  }

  tags = merge(
    var.tags,
    {
      Name = var.nic_name
    }
  )
}

# NAT Gateway
resource "azurerm_nat_gateway" "pcam_nat_gateway" {
  count               = var.create_nat_gateway ? 1 : 0
  name                = var.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout

  tags = merge(
    var.tags,
    {
      Name = var.nat_gateway_name
    }
  )
}

# NAT Gateway Public IP (required for NAT Gateway)
resource "azurerm_public_ip" "nat_gateway_public_ip" {
  count               = var.create_nat_gateway ? 1 : 0
  name                = "${var.nat_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    var.tags,
    {
      Name = "${var.nat_gateway_name}-pip"
    }
  )
}

# NAT Gateway Association
resource "azurerm_nat_gateway_public_ip_association" "pcam_nat_gateway_pip" {
  count                = var.create_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.pcam_nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.nat_gateway_public_ip[0].id
}

# NAT Gateway Subnet Association
resource "azurerm_subnet_nat_gateway_association" "pcam_nat_gateway_subnet" {
  count          = var.create_nat_gateway ? 1 : 0
  subnet_id      = azurerm_subnet.app_subnet.id
  nat_gateway_id = azurerm_nat_gateway.pcam_nat_gateway[0].id
}

# Application Gateway (optional)
resource "azurerm_application_gateway" "pcam_app_gateway" {
  count               = var.create_app_gateway ? 1 : 0
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.app_gateway_sku
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.app_subnet.id
  }

  frontend_port {
    name = "appGatewayFrontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = var.create_public_ip ? azurerm_public_ip.pcam_public_ip[0].id : null
  }

  backend_address_pool {
    name = "appGatewayBackendPool"
  }

  backend_http_settings {
    name                  = "appGatewayBackendHttpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "appGatewayHttpListener"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "appGatewayFrontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appGatewayRequestRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "appGatewayHttpListener"
    backend_address_pool_name  = "appGatewayBackendPool"
    backend_http_settings_name = "appGatewayBackendHttpSettings"
  }

  tags = merge(
    var.tags,
    {
      Name = var.app_gateway_name
    }
  )
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "pcam_private_dns" {
  count               = var.create_private_dns_zone ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      Name = var.private_dns_zone_name
    }
  )
}

# Private DNS Zone Link to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "pcam_private_dns_link" {
  count                 = var.create_private_dns_zone ? 1 : 0
  name                  = "${var.private_dns_zone_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pcam_private_dns[0].name
  virtual_network_id    = azurerm_virtual_network.pcam_vnet.id

  tags = merge(
    var.tags,
    {
      Name = "${var.private_dns_zone_name}-link"
    }
  )
}

# VNet Peering
resource "azurerm_virtual_network_peering" "pcam_peering" {
  count                     = var.create_vnet_peering && var.peer_vnet_id != null ? 1 : 0
  name                      = var.peer_vnet_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.pcam_vnet.name
  remote_virtual_network_id = var.peer_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Locals for easy reference
locals {
  vnet_info = {
    id               = azurerm_virtual_network.pcam_vnet.id
    name             = azurerm_virtual_network.pcam_vnet.name
    address_space    = azurerm_virtual_network.pcam_vnet.address_space
    location         = azurerm_virtual_network.pcam_vnet.location
    resource_group   = azurerm_virtual_network.pcam_vnet.resource_group_name
  }

  subnets_info = {
    app_subnet = {
      id               = azurerm_subnet.app_subnet.id
      name             = azurerm_subnet.app_subnet.name
      address_prefix   = azurerm_subnet.app_subnet.address_prefixes[0]
    }
    aks_subnet = {
      id               = azurerm_subnet.aks_subnet.id
      name             = azurerm_subnet.aks_subnet.name
      address_prefix   = azurerm_subnet.aks_subnet.address_prefixes[0]
    }
  }
}
