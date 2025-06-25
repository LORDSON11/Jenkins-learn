variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "private_key" {
  description = "Private key content (.pem) for SSH"
  type        = string
  sensitive   = true
}
