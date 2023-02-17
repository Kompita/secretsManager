

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = var.secret_id
  secret_string = jsonencode(var.secret_value)
}




