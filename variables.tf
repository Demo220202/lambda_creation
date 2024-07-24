variable "environment" {
  description = "The environment to deploy (dev, qa, beta, prod, dr)"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "existing_iam_role_name" {
  description = "The name of the existing IAM role"
  type        = string
}


variable "redis_endpoint" {
  description = "Redis endpoint"
  type        = string
  default     = ""
}

variable "redis_endpoint_prod" {
  description = "Redis endpoint for prod environment"
  type        = string
  default     = "testlambda-1os2ns.serverless.usw2.cache.amazonaws.com:6379"
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}

variable "lambda_layers" {
  description = "List of Lambda layers ARNs"
  type        = list(string)
  default     = []
}

variable "concurrency_limit" {
  description = "Concurrency limit for the Lambda function"
  type        = number
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "eventbridge_rule_name" {
  description = "EventBridge rule name"
  type        = string
}

variable "eventbridge_rule_schedule" {
  description = "EventBridge rule schedule expression"
  type        = string
}

variable "memory_size" {
  description = "Memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "ephemeral_storage" {
  description = "Ephemeral storage for the Lambda function in MB"
  type        = number
  default     = 512
}

variable "timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 30
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.8"
}

