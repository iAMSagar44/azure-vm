variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created."
  default     = "australiaeast"
}

variable "rg_name" {
  type        = string
  description = "The resource group name"
  default     = "web-app-dev-rg"
}

variable "vm_pwd" {
  type        = string
  description = "VM admin password"
  default     = "secret#44#20"
}

variable "vm_count" {
  type        = number
  description = "The number of VMs to create"
  default     = 2
}
