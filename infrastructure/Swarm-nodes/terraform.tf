terraform {
    backend "s3" {
        bucket = "terraform-tfstate-locks-jason-test11"
        key    = "swarm-nodes"
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