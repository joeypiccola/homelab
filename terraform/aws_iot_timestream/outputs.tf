output "grafana_user_access_key_secret" {
  description = "Access key secret"
  value       = aws_iam_access_key.lb.secret
  sensitive   = true
}
output "grafana_user_access_key_id" {
  description = "Access key id"
  value       = aws_iam_access_key.lb.id
}

data "aws_iot_endpoint" "example" {}

output "aws_iot_endpoint_endpoint_address" {
  description = "IoT Core Endpoint Address"
  value       = "mqtt://${data.aws_iot_endpoint.example.endpoint_address}:8883"
}

output "iot_thing_name" {
  description = "IoT Thing name"
  value       = aws_iot_thing.example.name
}
