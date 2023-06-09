variable "subnet_name" {
  type    = string
  default = ""
}

variable "resource_group_name" {
  description = "A string that describes the name of the resource group."
  type        = string
}

variable "virtual_network_name" {
  description = "A string to describe the name of the subnet."
  type        = string
}

variable "network_security_group_rg" {
  description = "The Network Security Group RG to associate with the subnet. Default is the same RG than the subnet."
  type        = string
  default     = null
}

variable "address_prefixes" {
  description = "A list of the adress prefixes to use_remote_gateways."
}

# variable "address_prefixes" {
#   type    = set(string)
#   default = []
# }

variable "route_table_name" {
  description = "The Route Table name to associate with the subnet."
  type        = string
  default     = null
}

variable "route_table_rg" {
  description = "The Route Table RG to associate with the subnet. Default is the same RG than the subnet."
  type        = string
  default     = null
}

variable "subnet_delegation" {
  description = <<EOD
Configuration delegations on subnet
object({
  name = object({
    name = string,
    actions = list(string)
  })
})
EOD
  type        = map(list(any))
  default     = {}
}

variable "network_security_group_name" {
  description = "The Network Security Group name to associate with the subnets."
  type        = string
  default     = null
}

variable "service_endpoints" {
  description = "Tags to apply to all resources created."
  type        = list(string)
  default     = []
}