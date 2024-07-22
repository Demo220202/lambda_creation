variable "environment" {
  description = "The environment (dev, qa, beta, prod, dr)"
  type        = string
}

variable "region" {
  description = "The Region"
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

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
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

variable "subnet_ids" {
  description = "The subnet ID to use for the Lambda function"
  type        = list(string)
  default     = []
}

variable "eventbridge_rule_name" {
  description = "EventBridge rule name"
  type        = string
  default     = ""
}

variable "eventbridge_schedule_expression" {
  description = "EventBridge rule schedule expression"
  type        = string
  default     = "rate(10 minutes)"
}
