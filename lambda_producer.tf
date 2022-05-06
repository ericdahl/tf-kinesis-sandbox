data archive_file "lambda_producer" {
  source_file = "${path.module}/lambda/producer/main.py"

  output_path = "${path.module}/lambda/producer/target/main.zip"
  type        = "zip"
}


resource "aws_lambda_function" "producer" {
  function_name = "producer"
  handler       = "main.handler"
  role          = aws_iam_role.lambda_producer.arn
  runtime       = "python3.8"

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.stream.name
    }
  }

  filename         = data.archive_file.lambda_producer.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_producer.output_path)

}

resource "aws_cloudwatch_event_rule" "producer" {
    name = "producer"
    schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "producer" {
    rule = aws_cloudwatch_event_rule.producer.name
    target_id = "check_foo"
    arn = aws_lambda_function.producer.arn
}

resource "aws_lambda_permission" "producer" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.producer.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.producer.arn
}

resource "aws_cloudwatch_log_group" "producer" {
  name = "/aws/lambda/producer"
}
