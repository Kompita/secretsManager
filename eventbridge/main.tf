resource "aws_cloudwatch_event_bus" "custom_bus" {
  name = "test-lara"
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "custom_rule" {
  name        = "rotation_custom_rule"
  description = "Capture every secret rotation"

  event_pattern = <<EOF
{
  "source": [
    "demo.event"
  ]
}
EOF
}