variable "lambda_name" {
  description = "The base name of the Lambda function"
  type        = string
}

variable "environments" {
  description = "The list of environments for which the Lambda functions will be created"
  type        = list(string)
  default     = ["dev", "qa", "beta", "prod"]
}

variable "environment_dr" {
  description = "DR Env"
  type        = string
  default     = "dr"
}

variable "existing_iam_role_name" {
  description = "The name of the existing IAM role to attach to the Lambda function"
  type        = string
}

variable "dr_region" {
  description = "The region for the disaster recovery Lambda function"
  type        = string
  default     = "us-east-1"
}

variable "default_region" {
  description = "The default region for the Lambda functions"
  type        = string
  default     = "us-west-1"
}

provider "aws" {
  alias  = "default"
  region = var.default_region
  profile = "Aditya-demo"
}

provider "aws" {
  alias  = "dr"
  region = var.dr_region
  profile = "Aditya-demo"
}

data "aws_iam_role" "existing_role" {
  provider = aws.default
  name     = var.existing_iam_role_name
}

resource "aws_lambda_function" "zen_lambda" {
  count = length(var.environments)

  provider = aws.default

  function_name = "Zen-${var.environments[count.index]}-${var.lambda_name}"
  role          = data.aws_iam_role.existing_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  # Source code for the Lambda function from a local zip file
  filename = "lambda_function_payload.zip"

  # Optionally, you can add environment variables
  # environment {
  #   variables = {
  #     ENV = var.environments[count.index]
  #   }
  # }
}

resource "aws_lambda_function" "zen_lambda_dr" {
  
  provider = aws.dr

  function_name = "Zen-${var.environment_dr}-${var.lambda_name}"
  role          = data.aws_iam_role.existing_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  # Source code for the Lambda function from a local zip file
  filename = "lambda_function_payload.zip"

  # Optionally, you can add environment variables
  # environment {
  #   variables = {
  #     ENV = var.environments[count.index]
  #   }
  # }
}
