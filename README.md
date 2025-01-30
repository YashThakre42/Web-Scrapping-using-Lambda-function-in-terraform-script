**Project Structure & Purpose**

**lambda_function.py** → Lambda Function (Python Script)
This script scrapes webpage content from Amazon.com.
The scraped data is stored in an AWS S3 bucket.

**remote_backend.t**f → Terraform Remote Backend Configuration
Stores Terraform state in an S3 bucket for consistency.
Uses DynamoDB to lock the state and prevent conflicts when multiple users apply Terraform changes.

**terraform_web_scraper.tf** → Terraform Infrastructure Configuration
Provisions AWS resources, including:
S3 Bucket (for storing scraped data).
IAM Role & Policy (grants Lambda access to S3).
Lambda Function (executes the web scraping task).
