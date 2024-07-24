provider "aws" {
  region = var.region
}

data "aws_iam_role" "existing_role" {
  name = var.existing_iam_role_name
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.environment}-${var.function_name}-sg"
  description = "Security group for ${var.environment} environment"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = "Zen-${var.environment}-${var.function_name}"
  role          = data.aws_iam_role.existing_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = var.runtime
  memory_size   = var.memory_size
  ephemeral_storage {
    size = var.ephemeral_storage
  }
  timeout       = var.timeout

  dynamic "vpc_config" {
    for_each = var.vpc_id != "" && length(data.aws_subnets.private_subnets.ids) > 0 && length(var.security_group_ids) > 0 ? [1] : []
    content {
      subnet_ids         = data.aws_subnets.private_subnets.ids
      security_group_ids = var.security_group_ids
    }
  }

  environment {
    variables = {
      REDIS_ENDPOINT = var.environment == "prod" ? var.redis_endpoint_prod : var.redis_endpoint
    }
  }

  layers = var.lambda_layers

  reserved_concurrent_executions = var.concurrency_limit

  tags = {
    Name = "zenarate/${var.environment}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_lambda_alias" "lambda_alias" {
  name             = "${var.environment}-alias"
  function_name    = aws_lambda_function.lambda.function_name
  function_version = aws_lambda_function.lambda.version
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled.arn

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "scheduled" {
  name                = "Zen-${var.environment}-${var.function_name}-rule"
  schedule_expression = var.eventbridge_rule_schedule

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.scheduled.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.lambda.arn

  lifecycle {
    prevent_destroy = true
  }
}
