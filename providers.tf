terraform {
  backend "s3" {
    bucket = "dolapo-state-bucket-2"
    dynamodb_table = "state-lock"
    key = "build/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode-terraform"
}