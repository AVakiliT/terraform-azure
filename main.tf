variable "resource_group_name" {
  type = string
  default = "ps-tfazure-vnet-main"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "vnet_cidr_range" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixed" {
  type=list(string)
  default = [ "10.0.0.0/24", "10.0.0.1/24" ]
}

variable "subnet_names" {
  type = list(string)
  default = [ "web", "database"]
}

provider "azurerm" {
  features {}
}

module "vnet-main" {
  source = "Azure/vnet/azurerm"
  version = "4.0.0"
  resource_group_name = var.resource_group_name
  vnet_location = var.location
  vnet_name = var.resource_group_name
  address_space = var.vnet_cidr_range
  subnet_prefixes = var.subnet_names
  subnet_names = var.subnet_names
  nsg_ids = {}
  use_for_each = false

  tags = {
    environment = "dev"
    costcenter = "it"
  }
}

output "vnet_id" {
  value = module.vnet-main.vnet_id
}