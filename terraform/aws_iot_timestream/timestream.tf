resource "aws_timestreamwrite_database" "example" {
  database_name = "temp_metrics2"
}

resource "aws_timestreamwrite_table" "example" {
  database_name = aws_timestreamwrite_database.example.database_name
  table_name    = "sensorData2"

  retention_properties {
    magnetic_store_retention_period_in_days = 7
    memory_store_retention_period_in_hours  = 1
  }
}
