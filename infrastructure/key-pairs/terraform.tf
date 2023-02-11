terraform {
    backend "s3" {
        bucket = "terraform-tfstate-locks"
        key    = "key-pairs"
        region = "ca-central-1"
        dynamodb_table = "terraform-tfstate-lock-dynamo"
    }

    required_providers {
        aws = {
           version = ">=4"
           source = "hashicorp/aws"
        }
    }
}