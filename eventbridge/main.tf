resource "aws_cloudwatch_event_bus" "rotation_bus" {
  name = "rotation_bus"
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "rotation_rule" {
  name           = "rotation_rule"
  description    = "Capture every secret rotation"
  event_bus_name = aws_cloudwatch_event_bus.rotation_bus.name
  event_pattern  = file("${path.module}/event_pattern.json")
  /*
  event_pattern = <<EOF
{
  "source": [
    "demo.event"
  ]
}
EOF
*/
}

//Ejemplo para probar el funcionamiento y dlq

resource "aws_cloudwatch_event_target" "lambda_example" {
  rule           = aws_cloudwatch_event_rule.rotation_rule.name
  arn            = var.target_arn
  event_bus_name = aws_cloudwatch_event_bus.rotation_bus.name
    dead_letter_config {
    arn = aws_sqs_queue.eventbridge_dlq_example.arn
  }
}


resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_example" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "test-lara-event-from-eventbridge"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rotation_rule.arn
}

resource "aws_sqs_queue" "eventbridge_dlq_example" {
  name                      = "eventbridge_dlq_example"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  /*
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })
 

  tags = {
    Environment = "production"
  }

   */
}

resource "aws_sqs_queue_policy" "eventbridge_dlq_policy" {
  queue_url = aws_sqs_queue.eventbridge_dlq_example.id
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.eventbridge_dlq_example.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.rotation_rule.arn}"
        }
      }
    }
  ]
}
POLICY
}
/*
resource "aws_cloudwatch_event_target" "sqs_target_example" {
  rule           = aws_cloudwatch_event_rule.rotation_rule.name
  arn            = aws_sqs_queue.eventbridge_dlq_example.arn
  event_bus_name = aws_cloudwatch_event_bus.rotation_bus.name
  dead_letter_config {
    arn = aws_sqs_queue.eventbridge_dlq_example.arn
  }
}
*/
