data "archive_file" "lambda_producer" {
  source_file = "${path.module}/lambda/producer/main.py"
  output_path = "${path.module}/lambda/producer/target/main.zip"
  type        = "zip"
}
resource "aws_lambda_function" "producer" {
  for_each = toset(["1", "2", "3", "4", "5"]) # FIXME - use module? cleanup

  function_name = "producer-${each.value}"
  handler       = "main.handler"
  role          = aws_iam_role.lambda_producer.arn
  runtime       = "python3.8"

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.stream.name
      LAMBDA_ID           = each.value
    }
  }

  filename         = data.archive_file.lambda_producer.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_producer.output_path)
}

resource "aws_cloudwatch_event_rule" "producer" {
  for_each = aws_lambda_function.producer

  name                = each.value.id
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "producer" {
  for_each = aws_lambda_function.producer

  rule      = each.value.id
  target_id = each.value.id
  arn       = each.value.arn
}

resource "aws_lambda_permission" "producer" {
  for_each = aws_lambda_function.producer

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:us-east-1:${data.aws_caller_identity.current.account_id}:rule/${each.value.function_name}"
}

resource "aws_cloudwatch_log_group" "producer" {
  for_each = aws_lambda_function.producer

  name = "/aws/lambda/${each.value.function_name}"
}
