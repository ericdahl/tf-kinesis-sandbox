data "archive_file" "lambda_consumer" {
  source_file = "${path.module}/lambda/consumer/main.py"
  output_path = "${path.module}/lambda/consumer/target/main.zip"
  type        = "zip"
}

resource "aws_lambda_function" "consumer" {
  function_name = "consumer"
  handler       = "main.handler"
  role          = aws_iam_role.lambda_consumer.arn
  runtime       = "python3.8"
  filename         = data.archive_file.lambda_consumer.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_consumer.output_path)
}

resource "aws_lambda_event_source_mapping" "consumer" {
  event_source_arn  = aws_kinesis_stream.stream.arn
  function_name     = aws_lambda_function.consumer.arn
  starting_position = "LATEST"

  maximum_batching_window_in_seconds = 30
}

resource "aws_cloudwatch_log_group" "consumer" {
  name = "/aws/lambda/consumer"
}