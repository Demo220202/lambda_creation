variable "region" {
  description = "The region to deploy to"
  type        = string
}

variable "existing_iam_role_name" {
  description = "The name of the existing IAM role"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to associate with the Lambda function."
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the Lambda function."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "memory_size" {
  description = "The amount of memory available to the Lambda function"
  type        = number
}

variable "ephemeral_storage" {
  description = "The amount of ephemeral storage available to the Lambda function"
  type        = number
}

variable "timeout" {
  description = "The function execution time at which AWS Lambda should terminate the function"
  type        = number
}

variable "redis_endpoint" {
  description = "The Redis endpoint"
  type        = string
}

variable "redis_endpoint_prod" {
  description = "The Redis endpoint for production"
  type        = string
}

variable "lambda_layers" {
  description = "List of Lambda layers to attach to the function"
  type        = list(string)
}

variable "concurrency_limit" {
  description = "Reserved concurrent executions for the Lambda function"
  type        = number
}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}


variable "eventbridge_rule_schedule" {
  description = "The schedule expression for the EventBridge rule"
  type        = string
}
