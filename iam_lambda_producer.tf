resource "aws_iam_role" "lambda_producer" {
  name = "lambda-producer"

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


resource "aws_iam_role_policy_attachment" "lambda_producer_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_producer.name
}

resource "aws_iam_role_policy_attachment" "lambda_producer" {
  policy_arn = aws_iam_policy.lambda_producer.arn
  role       = aws_iam_role.lambda_producer.name
}


resource "aws_iam_policy" "lambda_producer" {
  name = "lambda-producer"

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
                "${aws_kinesis_stream.stream.arn}"
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