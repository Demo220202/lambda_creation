provider "aws" {
  region  = var.region
  #profile = "Aditya-demo"
}

data "aws_iam_role" "existing_role" {
  name = var.existing_iam_role_name
}

data "aws_security_group" "sg" {
  name = var.security_group_name
}

resource "aws_lambda_function" "lambda" {
  function_name = "Zen-${var.environment}-${var.function_name}"
  role          = data.aws_iam_role.existing_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "lambda_function_payload.zip"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [data.aws_security_group.sg.id]
  }

  environment {
    variables = {
      REDIS_ENDPOINT = var.redis_endpoint
    }
  }

  layers = var.lambda_layers

  reserved_concurrent_executions = var.concurrency_limit
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled.arn
}

resource "aws_cloudwatch_event_rule" "scheduled" {
  name                = "Zen-${var.environment}-${var.function_name}-rule"
  schedule_expression = var.eventbridge_rule_schedule
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.scheduled.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.lambda.arn
}
