
resource "aws_lambda_function" "job_lambda_add" {
  filename         = "${path.module}/lambda_code/addJob.js.zip"
  function_name    = "lambda_add_job"
  role             = "${aws_iam_role.role.arn}"
  handler          = "addJob.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/addJob.js.zip")}"
  environment {
    variables = {
    }
  }
}

resource "aws_lambda_function" "job_lambda_get" {
  filename         = "${path.module}/lambda_code/getJob.js.zip"
  function_name    = "lambda_get_job"
  role             = "${aws_iam_role.role.arn}"
  handler          = "getJob.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/getJob.js.zip")}"
  environment {
    variables = {
    }
  }
}

resource "aws_lambda_function" "lambda_add_content" {
  filename         = "${path.module}/lambda_code/addContent.js.zip"
  function_name    = "lambda_add_content"
  role             = "${aws_iam_role.role.arn}"
  handler          = "addContent.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/addContent.js.zip")}"
  environment {
    variables = {
    }
  }
}

resource "aws_lambda_event_source_mapping" "lambda_dynamodb_trigger" {
  event_source_arn  = aws_dynamodb_table.jobs.stream_arn
  function_name     = aws_lambda_function.lambda_add_content.function_name
  starting_position = "TRIM_HORIZON"
  
}