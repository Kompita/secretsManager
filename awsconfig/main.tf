

resource "aws_config_config_rule" "secretsmanager_rotation_enabled_check" {
  name = "secretsmanager_rotation_enabled_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
  }
  tags = local.tags
  //depends_on = [aws_config_configuration_recorder.secretsmanager_configuration_recorder]
}
/*
resource "aws_config_config_rule" "secretsmanager_rotation_success_check" {
  name = "secretsmanager_rotation_enabled_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_SCHEDULED_ROTATION_SUCCESS_CHECK"
  }
  tags = local.tags
  depends_on = [aws_config_configuration_recorder.secretsmanager_configuration_recorder]
}

resource "aws_config_config_rule" "secretsmanager_periodic_rotation" {
  name = "secretsmanager_rotation_enabled_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_SECRET_PERIODIC_ROTATION"
  }
  tags = local.tags
  depends_on = [aws_config_configuration_recorder.secretsmanager_configuration_recorder]
}

resource "aws_config_config_rule" "secretsmanager_secret_unused" {
  name = "secretsmanager_rotation_enabled_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_SECRET_UNUSED"
  }
  tags = local.tags
  depends_on = [aws_config_configuration_recorder.secretsmanager_configuration_recorder]
}

resource "aws_config_config_rule" "secretsmanager_secret_using_cmk" {
  name = "secretsmanager_rotation_enabled_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_USING_CMK"
  }
  tags = local.tags
  depends_on = [aws_config_configuration_recorder.secretsmanager_configuration_recorder]
}

resource "aws_config_configuration_recorder" "secretsmanager_configuration_recorder" {
  name     = "secretsmanager_configuration_recorder"
  role_arn = local.aws_service_rol_config
}
*/