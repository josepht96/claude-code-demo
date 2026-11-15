variable "name" {
  description = "Bucket name prefix; the account ID is appended to make it globally unique."
  type        = string
}

variable "versioning" {
  description = "Keep previous versions of overwritten or deleted objects."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Delete previous object versions this many days after they're replaced (only when versioning)."
  type        = number
  default     = 30
}

variable "expiration_days" {
  description = "Delete current objects this many days after creation. null = keep forever."
  type        = number
  default     = null
}

variable "force_destroy" {
  description = "Allow `terraform destroy` to delete the bucket even when it still holds objects. Handy for demos; keep false for real data."
  type        = bool
  default     = false
}
