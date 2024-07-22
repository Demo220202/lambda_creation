provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "Zen-${var.environment}-${var.function_name}"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "python3.8"
  filename      = "lambda_function_payload.zip"

  environment {
    variables = {
      REDIS_ENDPOINT = var.redis_endpoint
    }
  }

  vpc_config {
    security_group_ids = var.security_groups
    subnet_ids         = [var.subnet_id]  # Replace with your subnet IDs
  }

  layers = var.lambda_layers

  reserved_concurrent_executions = var.concurrency_limit
}

resource "aws_iam_role" "lambda_exec_role" {
  name = var.existing_iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*",
        "dynamodb:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
