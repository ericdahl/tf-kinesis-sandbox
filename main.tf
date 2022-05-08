provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name        = "tf-kinesis-sandbox"
      Provisioner = "Terraform"
    }
  }
}

variable "name" {
  default = "tf-kinesis-sandbox"
}

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

data "aws_caller_identity" "current" {}