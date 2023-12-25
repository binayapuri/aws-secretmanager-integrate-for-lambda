
# Lambda Function
resource "aws_lambda_function" "test_lambda" {
  function_name     = "adex_gpt_ADXGPT-30"
  handler           = "lambda_function.lambda_handler"
  role              = aws_iam_role.lambda_role.arn
  runtime           = "python3.8"
##  Assuming you have a data block for the Python package
  source_code_hash  = data.archive_file.python_lambda_package.output_base64sha256
  filename          = data.archive_file.python_lambda_package.output_path
  timeout           = 600
  memory_size       = 1024
  publish           = true

  environment {
    variables = {
      S3_BUCKET_NAME      = "adex-gpt-data-bucket"
      SERVICE_ACCOUNT_FILE = "secret/client_secret.json"
      DATA_FILE           = "/data/data_files"
      DRIVE_ENDPOINT      = jsondecode(aws_secretsmanager_secret_version.dereh["driive"].secret_string).endpoint
      CONFLUENCE_ENDPOINT      = jsondecode(aws_secretsmanager_secret_version.dereh["confluence"].secret_string).endpoint
      JIRA_ENDPOINT      = jsondecode(aws_secretsmanager_secret_version.dereh["jira"].secret_string).endpoint
    }
  }
}

# Archive File
data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/etl"
  output_path = "lambda.zip"
}



# IAM Role
resource "aws_iam_role" "lambda_role" {
  name             = "adexgpt_test_lambda_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

