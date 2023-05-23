variable "cohort3-uyi-rg" {
  description = "Name of the resource group"
  type        = string
  default     = "cohort3-uyi-rg"
}

variable "dev-vnet" {
  description = "Name of the virtual network"
  type        = string
  default     = "dev-vnet"
}

variable "subnet-names" {
  description = "List of subnet names"
  type        = list(string)
  default     = ["vm-subnet1", "vm-subnet2", "vm-subnet3"]
}

variable "vm-count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3  
}

variable "vm-prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "myvm"
}

variable "vm-image" {
  description = "VM image SKU"
  type        = string
  default     = "18.04-LTS"
}

variable "vm-size" {
  description = "VM instance size"
  type        = string
  default     = "Standard_B1s"
}
