output "key_name" {
  value = aws_key_pair.default.key_name
}

output "private_key_pem" {
  value     = tls_private_key.default.private_key_pem
  sensitive = true
}
