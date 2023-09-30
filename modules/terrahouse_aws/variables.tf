variable "user_uuid" {
  type        = string
  description = "User UUID"

  validation {
    condition     = can(regex("^([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})$", var.user_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426614174000)"
  }
}

variable "bucket_name" {
  type        = string
  description = "The name of the AWS S3 bucket"
  
  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Invalid S3 bucket name. Bucket names must be between 3 and 63 characters long and can only contain lowercase letters, numbers, hyphens, and periods."
  }
}