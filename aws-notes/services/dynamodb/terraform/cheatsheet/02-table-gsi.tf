# Add a Global Secondary Index (GSI)

variable "table_name" { type = string }

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "pk"
  range_key = "sk"

  attribute { name = "pk"  type = "S" }
  attribute { name = "sk"  type = "S" }
  attribute { name = "gpk" type = "S" }
  attribute { name = "gsk" type = "S" }

  global_secondary_index {
    name            = "gsi1"
    hash_key        = "gpk"
    range_key       = "gsk"
    projection_type = "ALL"
  }
}

# NOTE: グローバルテーブル（マルチリージョン複製）は
# aws_dynamodb_table の replica ブロック（provider v5）で定義します。
