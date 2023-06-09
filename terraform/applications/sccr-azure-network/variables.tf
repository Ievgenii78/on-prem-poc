#General variables related to the project
variable "resource_owner" {
  description = "Resource Owner for tags"
}

variable "subscriptionId" {
  description = "Resource Owner for tags"
}

variable "financial_identifier" {
  description = "Financial Identifier"
}

variable "project_name" {
  description = "Short name of the project that will be used in resource naming and tagging"
}

variable "location" {
  description = "Azure location"
}

variable "resource_group_name" {
  description = "Name of the resource group used"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

#Subnet variables

variable "virtual_network_name" {
  description = "Virtual Network that used for infrastructure"
  type        = string
}


