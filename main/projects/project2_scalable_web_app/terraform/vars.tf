
data "azuread_client_config" "current" {}


# user info
variable "admin_group1_name" {
  type = string
  description = "admin group name"
  default = "jd_admin_group1"
}

variable "admin_username" {
  type = string
  description = "admin username for vmss and mssql server"
  default = "adminuser"
}
variable "admin_password" {
  type = string
  description = "admin password for vmss and mssql server"
  sensitive = true
}


# Create a resource group
variable "rg_name" {
  type = string
  description = "Resource group name"
  default = "joshua_davis_rg"
}

variable "rg_location" {
  type = string
  description = "Resource group location"
  default = "eastus"
}

# Create a dashboard maybe


# Create a virtual network
variable "vnet_name" {
  type = string
  description = "Virtual network name"
  default = "jd_vnet"
}

# Create subnets
variable "web_subnet_name" {
  type = string
  description = "Subnet name"
  default = "web_subnet"  
}
variable "data_subnet_name" {
  type = string
  description = "Subnet name"
  default = "data_subnet"  
}


# Create network security groups
variable "web_nsg1_name" {
  type = string
  description = "web Network security group name"
  default = "jd_web_nsg1"  
}
variable "data_nsg1_name" {
  type = string
  description = "data Network security group name"
  default = "jd_data_nsg1"  
}

#Create Public IP
variable "pip1_name" {
  type = string
  description = "Public IP name"
  default = "lb_pip1"  
}

# Create load balancer
variable "lb1_name" {
  type = string
  description = "Load balancer name"
  default = "vmss_lb1" 
}


# Create virtual machines
variable "lvmss1_name" {
  type = string
  description = "Virtual machine scale set name"
  default = "lvmss1" 
}


# Create managed database
variable "mssql_server_name" {
  type = string
  description = "Managed database server name"
  default = "jdmssqlserver"  
}
variable "mssql_database_name" {
  type = string
  description = "Managed database name"
  default = "jd_mssql_database1"
}


# Create storage account
variable "sa1_name" {
  type = string
  description = "Storage account name"
  default = "jdsa1"
}
# variable "storage_account_key" {
#   sensitive = true
# }


# Create automation account?



variable "tags" {
  type = map
  description = "Tags"
  default = {
    "Created_By" = "Joshua Davis"
    "Course_Name" = "DevOps Apprenti Upskilling"
    "Project_Name" = "Project 2 - Azure Scalable Web Application"
  }
}
