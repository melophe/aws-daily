# Minimal DynamoDB table
# NOTE: provider/terraform blocks omitted on purpose.

variable "table_name" { type = string }

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # または "PROVISIONED" と read/write_capacity

  hash_key  = "pk"
  range_key = "sk"

  attribute { name = "pk" type = "S" }
  attribute { name = "sk" type = "S" }

  server_side_encryption { enabled = true }
}

