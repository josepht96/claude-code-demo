variable "name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR. Subnets are carved out as /24s, so it must be /16 or larger."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.cidr_block, 0)) && tonumber(split("/", var.cidr_block)[1]) <= 16
    error_message = "cidr_block must be a valid IPv4 CIDR of /16 or larger."
  }
}

variable "az_count" {
  description = "How many availability zones to spread subnets across."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 4
    error_message = "az_count must be between 1 and 4."
  }
}

variable "enable_nat_gateway" {
  description = "Give private subnets outbound internet through one NAT gateway (~$32/month plus data)."
  type        = bool
  default     = false
}
