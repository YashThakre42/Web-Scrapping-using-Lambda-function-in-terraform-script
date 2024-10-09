We will be able to store the contents of amazon.com into our S3 bucket using labda function.
1. Lambda Function (lambda_function.py)
   This Python code defines an AWS Lambda function that scrapes the content of a webpage (Amazon.com in this case) and stores it in an S3 bucket.
2. Terraform Remote Backend Configuration (remote_backend.tf)
   This file sets up the remote backend for Terraform to store its state file in an S3 bucket and lock the state using DynamoDB
3. Terraform Infrastructure Configuration (terraform_web_scrapper.tf)
    This Terraform configuration creates the necessary AWS resources like the S3 bucket, IAM role and policy for Lambda, and the Lambda function itself.
