provider "aws" {
  region  = "us-west-2"
  # profile = "Aditya-demo"
}

#provider "aws" {
  #alias   = "us-east-1"
  #region  = "us-east-1"
  # profile = "Aditya-demo"
#}

data "aws_security_group" "selected" {
  name = var.security_group_name
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  #provider = var.environment == "dr" ? aws.us-east-1 : aws

  name                = "${var.environment}-${var.function_name}-rule"
  schedule_expression = var.eventbridge_schedule_expression

  tags = {
    Environment = var.environment
    Function    = var.function_name
  }
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  #provider = var.environment == "dr" ? aws.us-east-1 : aws

  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  #provider = var.environment == "dr" ? aws.us-east-1 : aws

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}

resource "aws_lambda_function" "lambda_function" {
  #provider = var.environment == "dr" ? aws.us-east-1 : aws

  function_name = "Zen-${var.environment}-${var.function_name}"
  handler       = "lambda_function.lambda_handler"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.existing_iam_role_name}"
  runtime       = "python3.8"
  filename      = "lambda_function_payload.zip"

  environment {
    variables = {
      REDIS_ENDPOINT = var.redis_endpoint
    }
  }

  vpc_config {
    security_group_ids = [data.aws_security_group.selected.id]
    subnet_ids         = var.subnet_ids
  }

  layers = var.lambda_layers

  reserved_concurrent_executions = var.concurrency_limit
}

data "aws_caller_identity" "current" {}
