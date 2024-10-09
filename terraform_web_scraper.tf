terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68"
    }
  }

  required_version = ">= 1.9.0"
}
provider "aws"{
  region = "eu-central-1"  
}


#Creating the S3 Bucket
resource "aws_s3_bucket" "terra_web_scrap_bucket" {
  bucket = "terra-web-scrap-bucket"
  
  #versioning {
  #  enabled = true
  #}

  tags = {
    Name = "terra_web_scrap_bucket"
  }
}


#Creating the IAM Role and Create policy Attach Necessary Policies s3:PutObject, s3:ListBucket and Attaching terra_web_scrap_policy_attachment"
resource "aws_iam_role" "terra_web_scrap_role" {
  name = "terra_web_scrap_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "terra_web_scrap_policy" {
  name        = "terra_web_scrap_policy"
  description = "Policy for Lambda to interact with S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:PutObject", "s3:ListBucket"],
        Effect   = "Allow",
        Resource = [
          "${aws_s3_bucket.terra_web_scrap_bucket.arn}",
          "${aws_s3_bucket.terra_web_scrap_bucket.arn}/*"
        ]
      },
      {
        Action   = "logs:*",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}


#Attaching IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "terra_web_scrap_policy_attachment" {
  role       = aws_iam_role.terra_web_scrap_role.name
  policy_arn = aws_iam_policy.terra_web_scrap_policy.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.terra_web_scrap_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


#Create a ZIP file of the Python application
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python"
output_path = "${path.module}/lambda_function.zip"
}


#Add the aws_lambda_function function
resource "aws_lambda_function" "terra_web_scrap_lambda" {
filename                       = "${path.module}/lambda_function.zip"
function_name                  = "terra_web_scrap_lambda"
role                           =  aws_iam_role.terra_web_scrap_role.arn
handler                        = "lambda_function.lambda_handler"
runtime                        = "python3.12"
timeout                        =  60
publish                        =  true
}

# Grant invoke permission for Lambda 
#resource "aws_lambda_permission" "allow_s3_to_invoke" {
#  statement_id  = "AllowExecutionFromS3"
# action        = "lambda:InvokeFunction"
# function_name = aws_lambda_function.terra_web_scrap_lambda.function_name
#  principal     = "s3.amazonaws.com"
#}
