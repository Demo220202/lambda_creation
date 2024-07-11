variable "environment" {
  description = "The environment for the Lambda function (e.g., dev, prod)"
  type        = string
}

variable "function_name" {
  description = "The base name of the Lambda function"
  type        = string
}

variable "existing_iam_role_name" {
  description = "The name of the existing IAM role to attach to the Lambda function"
  type        = string
}

provider "aws" {
  region = "us-west-2"  # Change to your desired region
}
# profile = "Aditya-demo"

data "aws_iam_role" "existing_role" {
  name = var.existing_iam_role_name
}

resource "aws_lambda_function" "zen_lambda" {
  function_name = "Zen-${var.environment}-${var.function_name}"
  role          = data.aws_iam_role.existing_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  

  # Source code for the Lambda function
  filename = "lambda_function_payload.zip"

  # Environment variables
}

# terraform apply -var "environment=dev" -var "function_name=test1" -var "existing_iam_role_name=lamda-role"
#   environment {
#     variables = {
#       ENV = var.environment
#     }
#   }
