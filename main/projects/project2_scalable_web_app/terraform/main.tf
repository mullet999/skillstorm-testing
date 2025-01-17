
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.15.0"
    }
  }
}
provider "azurerm" {
    features {}
}

# Create a resource group: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg1" {
  name     = var.rg_name
  location = var.rg_location
  tags = var.tags
}

# Create a dashboard maybe


# Create a virtual network: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = []

  tags = var.tags
}


# Create subnets: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = var.web_subnet_name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]

  default_outbound_access_enabled = true

  # delegation {
  #   name = "delegation"

  #   service_delegation {
  #     name    = "Microsoft.ContainerInstance/containerGroups"
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
  #   }
  # }
}
resource "azurerm_subnet" "data_subnet" {
  name                 = var.data_subnet_name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]

  default_outbound_access_enabled = false
  service_endpoints = ["Microsoft.Sql","Microsoft.Storage"]
}

# Create network security groups: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = var.tags
}

# Create network security group rules: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
# resource "azurerm_network_security_rule" "inbound_nsg_rule1" {   # Wait to see what the default rules are
#   name                        = rule1
#   priority                    = 101
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg1.name
#   network_security_group_name = azurerm_network_security_group.nsg1.name
# }

# Subnet and NSG association: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "web_nsg1" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
resource "azurerm_subnet_network_security_group_association" "data_nsg1" {
  subnet_id                 = azurerm_subnet.data_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}


# Create public IP: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "pip1" {
  name                = var.pip1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
}

# Create load balancer: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb

resource "azurerm_lb" "lb1" {
  name                = var.lb1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  frontend_ip_configuration {
    name                 = var.pip1_name
    public_ip_address_id = azurerm_public_ip.pip1.id
  }
  tags = var.tags
}


# Create load balancer backend address pool: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool
resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool1" {
  loadbalancer_id = azurerm_lb.lb1.id
  name            = "BackEndAddressPool1"
}

# Create load balancer backend rule: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule
resource "azurerm_lb_rule" "lb_rule1" {
  loadbalancer_id                = azurerm_lb.lb1.id
  name                           = "LBRule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.pip1_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_address_pool1.id]
  probe_id                       = azurerm_lb_probe.lb1_probe.id
}

# Create load balancer backend probe: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe
resource "azurerm_lb_probe" "lb1_probe" {
  loadbalancer_id = azurerm_lb.lb1.id
  name            = "ssh-running-probe"
  port            = 22
}


# Create linux virtual machines(scale set): Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set
resource "azurerm_linux_virtual_machine_scale_set" "lvmss1" {
  name                = var.lvmss1_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku                 = "Standard_B1ls"
  instances           = 2
  admin_username      = "adminuser"
  admin_password      = var.lvmss1_admin_password  
  disable_password_authentication = false

  network_interface {
    name    = "lvmss1-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.web_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_address_pool1.id]
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  # health_probe_id = azurerm_lb_probe.lbp1.id
  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      "instances",
    ] 
  }
  depends_on = [azurerm_lb_rule.lb_rule1]
}


# Create managed database(mssql server and db): Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server  &  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database


# Create storage account: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account


# Create automation account?

