resource "aws_kinesis_firehose_delivery_stream" "extended_s3" {
  name        = "${var.name}-extended-s3"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.stream.arn
    role_arn           = aws_iam_role.firehose_read_stream.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_s3_write.arn
    bucket_arn = aws_s3_bucket.firehose_s3_destination.arn

    cloudwatch_logging_options {
      enabled = true
      log_group_name = "/aws/kinesisfirehose/${var.name}-extended-s3"
      log_stream_name = "foo"
    }

    #    processing_configuration {
    #      enabled = "true"
    #
    #      processors {
    #        type = "Lambda"
    #
    #        parameters {
    #          parameter_name  = "LambdaArn"
    #          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
    #        }
    #      }
    #    }
  }
}

resource "aws_cloudwatch_log_group" "extended_s3" {
  name = "/aws/kinesisfirehose/${aws_kinesis_firehose_delivery_stream.extended_s3.name}"
}

resource "aws_s3_bucket" "firehose_s3_destination" {
  bucket = "${var.name}-firehose-s3-destination"

  force_destroy = true
}