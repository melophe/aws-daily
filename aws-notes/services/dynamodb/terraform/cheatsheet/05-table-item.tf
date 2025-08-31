# Put a single item (small use-cases)

variable "table_name" { type = string }

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  attribute { name = "pk" type = "S" }
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.this.name
  hash_key   = "pk"
  item       = jsonencode({ pk = { S = "USER#1" }, payload = { S = "{}" } })
}

# NOTE: 大量データ投入には適していません。Boto3/CLI のバッチ/SDK を推奨。

