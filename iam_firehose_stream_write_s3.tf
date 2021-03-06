resource "aws_iam_role" "firehose_s3_write" {
  name = "${var.name}-firehose"

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

resource "aws_iam_policy" "firehose_s3_write" {
  name = "${var.name}-firewhose-s3-write"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.firehose_s3_destination.arn}",
                "${aws_s3_bucket.firehose_s3_destination.arn}/*"
            ]
        },
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

resource "aws_iam_role_policy_attachment" "firehose_s3_write" {
  role       = aws_iam_role.firehose_s3_write.name
  policy_arn = aws_iam_policy.firehose_s3_write.arn
}