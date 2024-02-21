output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_function_version" {
  value = aws_lambda_function.this.version
}