resource "aws_iam_role" "lambda_consumer" {
  name = "lambda-consumer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "lambda_consumer_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_consumer.name
}

resource "aws_iam_role_policy_attachment" "lambda_consumer" {
  policy_arn = aws_iam_policy.lambda_consumer.arn
  role       = aws_iam_role.lambda_consumer.name
}


resource "aws_iam_policy" "lambda_consumer" {
  name = "lambda-consumer"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:*"
            ],
            "Resource": [
                "${aws_kinesis_stream.stream.arn}",
                "${aws_kinesis_stream_consumer.lambda_consumer_fan_out.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:ListStreams"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}