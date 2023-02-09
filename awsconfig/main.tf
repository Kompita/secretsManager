resource "aws_config_config_rule" "secretsmanager_rotation_enabled_check" {
  name = "secretsmanager_rotation_enabled_check"

  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.secretsmanager_configuration_recorder]
}

resource "aws_config_configuration_recorder" "secretsmanager_configuration_recorder" {
  name     = "secretsmanager_configuration_recorder"
  role_arn = local.aws_service_rol_config
}