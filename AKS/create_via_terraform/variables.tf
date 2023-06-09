variable "location" {
  description = "The Azure Region to use"
  default     = "Australia East"
  type        = string
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  default     = "aks-testing"
  type        = string
}

variable "vm_size" {
  description = "The size of the VMs"
  default     = "standard_D2ads_v5" // standard_b4ms
  type        = string
}
