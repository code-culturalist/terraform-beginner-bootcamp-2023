variable "terratowns_endpoints" {
    type = string
}

variable "terratowns_access_token" {
    type = string
}

variable "teacherseat_user_uuid" {
    type = string
}

variable "musique" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "bach" {
  type = object({
    public_path = string
    content_version = number
  })
}