resource "aws_config_config_rule" "secretsmanager_rotation_enabled_check" {
  name = "secretsmanager_rotation_enabled_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_ROTATION_ENABLED_CHECK"
  }
}

resource "aws_config_config_rule" "secretsmanager_rotation_success_check" {
  name = "secretsmanager_rotation_success_check"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_SCHEDULED_ROTATION_SUCCESS_CHECK"
  }
}

resource "aws_config_config_rule" "secretsmanager_periodic_rotation" {
  name = "secretsmanager_periodic_rotation"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_SECRET_PERIODIC_ROTATION"
  }
}

resource "aws_config_config_rule" "secretsmanager_secret_unused" {
  name = "secretsmanager_secret_unused"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_SECRET_UNUSED"
  }
}

resource "aws_config_config_rule" "secretsmanager_secret_using_cmk" {
  name = "secretsmanager_secret_using_cmk"
  source {
    owner             = "AWS"
    source_identifier = "SECRETSMANAGER_USING_CMK"
  }
}
