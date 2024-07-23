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

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = ["subnet-12345"]
}

variable "redis_endpoint" {
  description = "Redis endpoint"
  type        = string
  default     = ""
}

variable "redis_endpoint_prod" {
  description = "Redis endpoint for prod environment"
  type        = string
  default     = ""
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
