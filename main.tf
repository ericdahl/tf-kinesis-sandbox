provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name        = "tf-kinesis-sandbox"
      Provisioner = "Terraform"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kinesis_stream" "stream" {
  name        = var.name
  shard_count = 1

  shard_level_metrics = [
    "IncomingRecords",
    "OutgoingRecords",
    "ReadProvisionedThroughputExceeded",
    "WriteProvisionedThroughputExceeded",
  ]
}
