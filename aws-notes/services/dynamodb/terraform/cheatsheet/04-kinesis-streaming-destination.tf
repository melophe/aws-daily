# Kinesis Streaming Destination for DynamoDB

variable "table_name" { type = string }

resource "aws_kinesis_stream" "this" {
  name             = "example-stream"
  shard_count      = 1
  retention_period = 24
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "pk"
  range_key = "sk"

  attribute { name = "pk" type = "S" }
  attribute { name = "sk" type = "S" }
}

resource "aws_dynamodb_kinesis_streaming_destination" "this" {
  stream_arn = aws_kinesis_stream.this.arn
  table_name = aws_dynamodb_table.this.name
}

