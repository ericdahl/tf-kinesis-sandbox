resource "aws_iam_role" "firehose_read_stream" {
  name = "${var.name}-firehose-read-stream"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "firehose_read_stream" {
  name = "${var.name}-firewhose-read-stream"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords",
                "kinesis:ListShards"
            ],
            "Resource": "${aws_kinesis_stream.stream.arn}"
        },
        {
           "Effect": "Allow",
           "Action": [
               "logs:PutLogEvents",
               "logs:CreateLogStream"
           ],
           "Resource": [
               "*"
           ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "firehose_read_stream" {
  role       = aws_iam_role.firehose_read_stream.name
  policy_arn = aws_iam_policy.firehose_read_stream.arn
}