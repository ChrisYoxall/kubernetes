variable "location" {
  description = "The Azure Region to use"
  default     = "Australia East"
  type        = string
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  default     = "aks-test"
  type        = string
}

variable "vm_size" {
  description = "The size of the VMs"
  default     = "standard_d4ads_v5" // standard_b4ms_v2
  type        = string
}
