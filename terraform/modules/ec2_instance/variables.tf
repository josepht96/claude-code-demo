variable "name" {
  description = "Name for the instance and its IAM/SG resources, e.g. demo-dev-web."
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch into. A public subnet gets a public IP automatically."
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "architecture" {
  description = "AMI architecture; must match instance_type (x86_64 for t3, arm64 for t4g)."
  type        = string
  default     = "x86_64"

  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "architecture must be x86_64 or arm64."
  }
}

variable "root_volume_size" {
  description = "GiB."
  type        = number
  default     = 8
}

variable "allowed_http_cidrs" {
  description = "IPv4 CIDRs allowed to reach port 80. Empty = no inbound traffic at all."
  type        = list(string)
  default     = []
}

variable "bucket_name" {
  description = "S3 bucket the instance can read and write (shown on the status page). null = none."
  type        = string
  default     = null
}

variable "bucket_arn" {
  description = "ARN of bucket_name, for the instance role's policy. null = no bucket access."
  type        = string
  default     = null
}

variable "instance_running" {
  description = "false = stop the instance (keeps it and its volume, stops the instance-hour charges)."
  type        = bool
  default     = true
}
