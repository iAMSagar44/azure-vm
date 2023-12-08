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

variable "plan_tier" {
  type        = string
  description = "The tier of app service plan to create"
  default     = "Basic"
}

variable "plan_sku" {
  type        = string
  description = "The sku of app service plan to create"
  default     = "B1"
}

variable "environment" {
  type        = string
  description = "Name of the deployment environment"
  default     = "dev"
}

variable "vm_pwd" {
  type        = string
  description = "VM admin password"
  default     = "secret#44#20"
}
