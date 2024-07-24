provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "lambda_sg" {
  for_each = var.vpc_id

  vpc_id = each.value
  name   = "${each.key}-lambda-sg"
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${each.key}-lambda-sg"
    }
  )
}

resource "aws_lambda_function" "lambda" {
  for_each = var.vpc_id

  function_name = "${each.key}-lambda"
  role          = var.iam_role[each.key]
  handler       = "lambda_function.lambda_handler"
  runtime       = var.runtime
  memory_size   = var.lambda_config[each.key].memory_size
  timeout       = var.lambda_config[each.key].timeout
  ephemeral_storage = var.lambda_config[each.key].ephemeral_storage

  vpc_config {
    subnet_ids         = data.aws_subnets.private.ids
    security_group_ids = [aws_security_group.lambda_sg[each.key].id]
  }

  layers = var.lambda_layers[each.key]

  source_code_hash = filebase64sha256("lambda.zip")
  filename          = "lambda.zip"

  tags = merge(
    var.tags,
    {
      Name = "${each.key}-lambda"
    }
  )
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id[each.key]
  filter {
    name   = "tag:aws:cloudformation:stack-name"
    values = ["private"]
  }
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  for_each = var.eventbridge_schedule

  name        = "Zen-${each.key}-lambda-rule"
  schedule_expression = each.value

  tags = merge(
    var.tags,
    {
      Name = "Zen-${each.key}-lambda-rule"
    }
  )
}

resource "aws_cloudwatch_event_target" "event_target" {
  for_each = var.eventbridge_schedule

  rule      = aws_cloudwatch_event_rule.event_rule[each.key].name
  arn       = aws_lambda_function.lambda[each.key].arn
  target_id = "${each.key}-target"

  input_transformer {
    input_paths = {
      "key1" = "$.detail.key1"
    }
  }
}

resource "aws_lambda_alias" "lambda_alias" {
  for_each = var.vpc_id

  name             = "latest"
  function_name    = aws_lambda_function.lambda[each.key].function_name
  function_version = "$LATEST"
}
