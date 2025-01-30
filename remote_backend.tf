terraform {
  backend "s3" {
    bucket = "yash-remote-backend-tf-files"
    key    = "Terraform_Web_scraper_data/terraform.tfstate "
    region = "eu-central-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}
