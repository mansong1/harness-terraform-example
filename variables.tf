variable "endpoint" {
  type        = string
  description = "The Harness API endpoint"
  default     = "https://app.harness.io/gateway"
}

variable "account_id" {
  type        = string
  description = "The id of of your Harness Account."
  default     = ""
}

variable "platform_api_key" {
  type        = string
  description = "This is either your Harness user PAT or Harness Service account token."
  default     = ""
}

variable "org_id" {
  type        = string
  description = "The id of of your Harness Organization."
  default     = "default"
}
