variable "lambda_name" {
  description = "The base name of the Lambda function"
  type        = string
}

variable "environments" {
  description = "The list of environments for which the Lambda functions will be created"
  type        = list(string)
  default     = ["dev", "qa", "beta", "prod"]
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
  count = length(var.environments)
  
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
