# output the fqdn of the new record
output "app_url" {
  description = "The URL of the web app."
  value       = "https://${aws_route53_record.record.fqdn}"
}
