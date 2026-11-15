variable "project" {
  description = "Short project name, used as a prefix for resource names and the Project tag."
  type        = string
  default     = "demo"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "aws_profile" {
  description = "AWS CLI profile to use. null = the default credential chain (AWS_PROFILE, env vars, SSO, ...)."
  type        = string
  default     = null
}

variable "allowed_account_ids" {
  description = "AWS account IDs this env may be applied to. Empty = no check."
  type        = list(string)
  default     = []
}

# ---- Network ----

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "enable_nat_gateway" {
  description = "Outbound internet for private subnets (~$32/month)."
  type        = bool
  default     = false
}

# ---- Storage ----

variable "bucket_force_destroy" {
  description = "Let `terraform destroy` empty and delete the app bucket."
  type        = bool
  default     = false
}

# ---- Compute ----

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "allowed_http_cidrs" {
  description = "CIDRs allowed to reach the web instance on port 80, e.g. [\"203.0.113.4/32\"] for just your IP."
  type        = list(string)
  default     = []
}

variable "instance_running" {
  description = "false = stop the web instance to save cost without destroying it."
  type        = bool
  default     = true
}
