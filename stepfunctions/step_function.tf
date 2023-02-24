resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.step_function_name
  role_arn = aws_iam_role.step_function_role.arn

  definition = templatefile("${path.module}/stepfunctions_files/stepfunction_definition.tftpl",{
    "FUNCTION_ARN" = "${aws_lambda_function.lambda_function.arn}"
  })
}

resource "aws_iam_role" "step_function_role" {
  name               = "${var.step_function_name}-role"
  assume_role_policy = templatefile("${path.module}/stepfunctions_files/assume_role_policy.tftpl",{})
}

resource "aws_iam_role_policy" "step_function_policy" {
  name    = "${var.step_function_name}-policy"
  role    = aws_iam_role.step_function_role.id
  policy = templatefile("${path.module}/stepfunctions_files/invoke_function_policy.tftpl", {
    "FUNCTION_ARN" =  "${aws_lambda_function.lambda_function.arn}"
  })
}
