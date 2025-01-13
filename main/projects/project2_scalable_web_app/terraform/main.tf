
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.15.0"
    }
  }
}
provider "azurerm" {
    # subscription_id = var.ARM_SUBSCRIPTION_ALTER
    # client_id       = var.ARM_CLIENT_ID
    # client_secret   = var.ARM_CLIENT_SECRET
    # tenant_id       = var.ARM_TENANT_ID

    resource_provider_registrations="none"

    features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.rg_name
  location = var.rg_location
}

# Create a dashboard


# Create a virtual network


# Create subnets


# Create network security groups


# Create load balancer


# Create virtual machines


# Create managed database


# Create storage account


# Create automation account?

