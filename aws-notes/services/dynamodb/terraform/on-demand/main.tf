variable "table_name" { type = string }

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # オンデマンド

  hash_key  = "pk"
  range_key = "sk"

  attribute { name = "pk" type = "S" }
  attribute { name = "sk" type = "S" }

  server_side_encryption { enabled = true }

  ttl { attribute_name = "ttl" enabled = true }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {
    Name        = var.table_name
    Environment = "dev"
  }
}

output "table_arn"  { value = aws_dynamodb_table.this.arn }
output "stream_arn" { value = aws_dynamodb_table.this.stream_arn }
