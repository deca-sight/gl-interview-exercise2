resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = tls_private_key.default.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.default.private_key_pem
  filename        = "${path.module}/../../generated_keys/${var.key_name}.pem"
  file_permission = "0600"
}
