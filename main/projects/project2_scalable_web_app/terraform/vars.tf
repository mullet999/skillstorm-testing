
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
  default = "joshua_davis_vnet"
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
variable "nsg1_name" {
  type = string
  description = "Network security group name"
  default = "joshua_davis_nsg1"  
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

variable "lvmss1_admin_password" {
  type = string
  description = "Virtual machine scale set admin password"
  sensitive = true
}


# Create managed database


# Create storage account


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
