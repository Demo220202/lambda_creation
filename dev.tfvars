environment            = "dev"
function_name          = "myLambda"
existing_iam_role_name = "lamda-role"
redis_endpoint         = ""
redis_endpoint_prod    = ""
security_group_name    = "dev-myLambda-sg"
security_group_ids     = []
lambda_layers          = []
concurrency_limit      = 0
region                 = "us-west-2"
vpc_id                 = "vpc-088189d5d80514ac3"
eventbridge_rule_name  = "Zen-dev-myLamda-rule"
eventbridge_rule_schedule = "rate(5 minutes)"
memory_size            = 128
ephemeral_storage      = 512
timeout                = 30
runtime                = "python3.8"
