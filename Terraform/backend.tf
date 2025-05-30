terraform {
  backend "s3" {
    bucket         = "techi-krish-state" # Replace with your S3 bucket name
    key            = "three-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "techi-krish-locks" # Replace with your DynamoDB table name
  }
}
