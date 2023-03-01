terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

variable "resource_group_name" {
  type = string
  default = "ps-tfaz-vnet-main"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "vnet_cidr_range" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  type=list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "subnet_names" {
  type = list(string)
  default = [ "web", "database"]
}

provider "azurerm" {
  # subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

module "vnet-main" {
  source = "Azure/vnet/azurerm"
  version = "4.0.0"
  resource_group_name = var.resource_group_name
  vnet_location = azurerm_resource_group.rg.location
  vnet_name = azurerm_resource_group.rg.name
  address_space = var.vnet_cidr_range
  subnet_prefixes = var.subnet_prefixes
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