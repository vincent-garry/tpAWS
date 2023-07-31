resource "aws_apigatewayv2_api" "gateway" {
  name = "jobsService"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.job_lambda_add.invoke_arn
}

resource "aws_apigatewayv2_integration" "lambda_integration_2" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.job_lambda_get.invoke_arn
}

resource "aws_apigatewayv2_route" "route_add" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /AddJob"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "route_get" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /GetJob"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration_2.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.job_lambda_add.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_permission1" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.job_lambda_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
}

resource "aws_lambda_permission" "invoke_lambda_permission" {
  statement_id  = "AllowInvokeFromDynamoDB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_add_content.function_name

  principal     = "dynamodb.amazonaws.com"
  source_arn    = aws_dynamodb_table.jobs.arn
}

output "api_endpoint" {
    value = aws_apigatewayv2_api.gateway.api_endpoint
}
output "stage_url" {
    value = aws_apigatewayv2_stage.default.invoke_url
}