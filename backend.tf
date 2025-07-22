//terraform {
//  backend "s3" {
//    bucket         = "infra-org-tfstate"      # replace with your bucket 
//    key            = "org/terraform.tfstate"
//    region         = "us-east-1"
//    dynamodb_table = "infra-org-tflock"       # table for locking
//    encrypt        = true
//  }
//}

resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_s3_bucket_name
}

resource "aws_dynamodb_table" "tflock" {
  name         = var.tflock_dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

