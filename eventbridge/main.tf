resource "aws_cloudwatch_event_bus" "rotation_bus" {
  name = "rotation_bus"
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "rotation_rule" {
  name           = "rotation_rule"
  description    = "Capture every secret rotation"
  event_bus_name = aws_cloudwatch_event_bus.rotation_bus.name
  event_pattern  = file("${path.module}/event_pattern.json")
}

//recibe como parámetro el target_arn, se añaden permisos para una lambda por motivos de testeo. 
resource "aws_cloudwatch_event_target" "rotation_event_target" {
  rule           = aws_cloudwatch_event_rule.rotation_rule.name
  arn            = var.target_arn
  event_bus_name = aws_cloudwatch_event_bus.rotation_bus.name
    dead_letter_config {
    arn = aws_sqs_queue.rotation_eventbridge_dlq_example.arn
  }
}

//TODO: eliminar este elemento. Solo esta para poder probar el módulo. 
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_example" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "test-lara-event-from-eventbridge"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rotation_rule.arn
}

//TODO: se lanza una cola sqs para ejemplificar como añadir una dlq. Utilizar una existente que nos provean
resource "aws_sqs_queue" "rotation_eventbridge_dlq_example" {
  name                      = "rotation_eventbridge_dlq_example"
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

//Política para permitir que eventbridge llame a la cola dlq
resource "aws_sqs_queue_policy" "eventbridge_dlq_policy" {
  queue_url = aws_sqs_queue.rotation_eventbridge_dlq_example.id

  policy = templatefile("${path.module}/eventbridge_dlq_policy.tftpl", {
    "RESOURCE_ARN" = "${aws_sqs_queue.rotation_eventbridge_dlq_example.arn}",
    "SOURCE_ARN" = "${aws_cloudwatch_event_rule.rotation_rule.arn}"
  })
}
