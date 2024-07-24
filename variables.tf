variable "vpc_id" {
  type = map(string)
  description = "Map of VPC IDs for each environment."
}

variable "lambda_layers" {
  type = map(list(string))
  description = "Map of Lambda layers ARNs for each environment."
}

variable "iam_role" {
  type = map(string)
  description = "Map of IAM role ARNs for each environment."
}

variable "eventbridge_schedule" {
  type = map(string)
  description = "Map of EventBridge schedule expressions for each environment."
}

variable "lambda_config" {
  type = map(object({
    memory_size       = number
    ephemeral_storage = number
    timeout           = number
  }))
  description = "Map of Lambda configuration settings for each environment."
}

variable "runtime" {
  type        = string
  description = "Lambda runtime environment."
}

variable "tags" {
  type = map(string)
  description = "Tags for the resources."
}
