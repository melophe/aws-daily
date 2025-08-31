variable "table_name" { type = string }
variable "read_min"  { type = number; default = 1 }
variable "read_max"  { type = number; default = 100 }
variable "write_min" { type = number; default = 1 }
variable "write_max" { type = number; default = 100 }

resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_min
  write_capacity = var.write_min

  hash_key  = "pk"
  range_key = "sk"

  attribute { name = "pk" type = "S" }
  attribute { name = "sk" type = "S" }

  server_side_encryption { enabled = true }

  tags = {
    Name        = var.table_name
    Environment = "dev"
  }
}

# Read autoscaling
resource "aws_appautoscaling_target" "read" {
  max_capacity       = var.read_max
  min_capacity       = var.read_min
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read" {
  name               = "${var.table_name}-read-target-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read.resource_id
  scalable_dimension = aws_appautoscaling_target.read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = 70
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Write autoscaling
resource "aws_appautoscaling_target" "write" {
  max_capacity       = var.write_max
  min_capacity       = var.write_min
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write" {
  name               = "${var.table_name}-write-target-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write.resource_id
  scalable_dimension = aws_appautoscaling_target.write.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = 70
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

output "table_arn" { value = aws_dynamodb_table.this.arn }
