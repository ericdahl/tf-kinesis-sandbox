resource "aws_kinesis_stream_consumer" "lambda_consumer_fan_out" {
  name       = "lambda_consumer_fan_out"
  stream_arn = aws_kinesis_stream.stream.arn
}

resource "aws_lambda_function" "consumer_fan_out" {
  function_name = "consumer_fan_out"
  handler       = "main.handler"
  role          = aws_iam_role.lambda_consumer.arn
  runtime       = "python3.8"
  filename         = data.archive_file.lambda_consumer.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_consumer.output_path)
}

resource "aws_lambda_event_source_mapping" "consumer_fan_out" {
  event_source_arn  = aws_kinesis_stream_consumer.lambda_consumer_fan_out.arn
  function_name     = aws_lambda_function.consumer_fan_out.arn
  starting_position = "LATEST"

  maximum_batching_window_in_seconds = 30
}

resource "aws_cloudwatch_log_group" "consumer_fan_out" {
  name = "/aws/lambda/consumer_fan_out"
}