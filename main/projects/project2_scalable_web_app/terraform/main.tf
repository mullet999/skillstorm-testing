
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.15.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
}
provider "azurerm" {
    features {}
}
provider "azuread" {
}


# Create an entra id group: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group
resource "azuread_group" "admin_group1" {
  display_name     = var.admin_group1_name
  prevent_duplicate_names = true
  owners           = [data.azuread_client_config.current.object_id]
  members          = [data.azuread_client_config.current.object_id, azurerm_linux_virtual_machine_scale_set.lvmss1.identity.0.principal_id]
  security_enabled = true
}

# Create a resource group: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg1" {
  name     = var.rg_name
  location = var.rg_location
  tags = var.tags
}

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
  service_endpoints = ["Microsoft.Sql","Microsoft.Storage"]
}
resource "azurerm_subnet" "data_subnet" {
  name                 = var.data_subnet_name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]

  default_outbound_access_enabled = true
  service_endpoints = ["Microsoft.Sql","Microsoft.Storage"]
}

# Create network security groups: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "web_nsg1" {
  name                = var.web_nsg1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = var.tags
}
resource "azurerm_network_security_group" "data_nsg1" {
  name                = var.data_nsg1_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = var.tags
}


# Create network security group rules: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "inbound_nsg_rule1" {
  name                        = "rule1"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefixes  = azurerm_subnet.web_subnet.address_prefixes #"*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.web_nsg1.name
}
resource "azurerm_network_security_rule" "inbound_nsg_rule2" {
  name                        = "rule2"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "209.239.36.169"
  destination_address_prefixes  = azurerm_subnet.web_subnet.address_prefixes #"*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.web_nsg1.name
}


# Subnet and NSG association: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "web_nsg1" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg1.id
}
resource "azurerm_subnet_network_security_group_association" "data_nsg1" {
  subnet_id                 = azurerm_subnet.data_subnet.id
  network_security_group_id = azurerm_network_security_group.data_nsg1.id
}

# Create private endpoint: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
resource "azurerm_private_endpoint" "mssql_private_endpoint" {
  name                = "mssql_private_endpoint"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  subnet_id           = azurerm_subnet.data_subnet.id

  private_service_connection {
    name                           = "mssql_privateserviceconnection"
    private_connection_resource_id = azurerm_mssql_server.mssql_server1.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "mssql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.mssql_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "mssql_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mssql_dns_network_link" {
  name                  = "mssql-link"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.mssql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet1.id
}

resource "azurerm_private_endpoint" "sa_blob_private_endpoint" {
  name                = "sa_blob_private_endpoint"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  subnet_id           = azurerm_subnet.data_subnet.id

  private_service_connection {
    name                           = "sa_blob_privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.sa1.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "sa_blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sa_blob_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "sa_blob_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sa_blob_dns_network_link" {
  name                  = "sa-blob-link"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.sa_blob_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet1.id
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
resource "azurerm_lb_rule" "lb_rule2" {
  loadbalancer_id                = azurerm_lb.lb1.id
  name                           = "LBRule2"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = var.pip1_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_address_pool1.id]
  probe_id                       = azurerm_lb_probe.lb1_probe.id
}

# Create load balancer backend probe: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe
resource "azurerm_lb_probe" "lb1_probe" {
  loadbalancer_id = azurerm_lb.lb1.id
  name            = "web-running-probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

# Create linux virtual machines(scale set): Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set
resource "azurerm_linux_virtual_machine_scale_set" "lvmss1" {
  name                = var.lvmss1_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku                 = "Standard_B1ls"
  instances           = 2
  admin_username      = var.admin_username
  admin_password      = var.admin_password  
  disable_password_authentication = false

  network_interface {
    name    = "lvmss1-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.web_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_address_pool1.id]
      # public_ip_address {
      #   name                = "first"
      #   public_ip_prefix_id = azurerm_public_ip_prefix.main.id
      # }
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

  # custom_data = filebase64("vmss_application/setup-app.sh") # Replace with the path to your startup script
  custom_data = base64encode(file("vmss_application/setup-app.sh"))

  tags = var.tags

  depends_on = [azurerm_lb_rule.lb_rule1]
}


# Create managed database(mssql server and db): Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server  &  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database
resource "azurerm_mssql_server" "mssql_server1" {
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.rg1.name
  location                     = azurerm_resource_group.rg1.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"

  public_network_access_enabled = false

  azuread_administrator {
    login_username = var.admin_group1_name
    object_id      = azuread_group.admin_group1.object_id
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "mssql_db1" {
  name         = "${var.mssql_server_name}-db1"
  server_id    = azurerm_mssql_server.mssql_server1.id
  max_size_gb  = 2
  sku_name     = "Basic"

  tags = var.tags
}

# Create storage account: Link to terraform registry - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account & https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_account" "sa1" {
  name                = var.sa1_name
  resource_group_name = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = true

  network_rules {
    bypass = []
    default_action             = "Allow" #"Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []#[azurerm_subnet.data_subnet.id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "sa1_c1" {
  name                  = "sa1-c1"
  storage_account_id    = azurerm_storage_account.sa1.id
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "web_app_zip" {
  name                   = "my-web-app.zip"
  storage_account_name   = azurerm_storage_account.sa1.name
  storage_container_name = azurerm_storage_container.sa1_c1.name
  type                   = "Block"
  source                 = "vmss_application/my-web-app.zip"
}



# Create automation account?

