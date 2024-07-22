variable "environment" {
  description = "The environment for the Lambda function"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "existing_iam_role_name" {
  description = "The existing IAM role name to use for the Lambda function"
  type        = string
}

variable "redis_endpoint" {
  description = "The Redis endpoint"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "concurrency_limit" {
  description = "Concurrency limit for the Lambda function"
  type        = number
  default     = 5
}

variable "lambda_layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}
