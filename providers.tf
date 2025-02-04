####################################################################################################
# Terraform Configuration: Backend and Required Providers
#
# This block sets up the Terraform backend and specifies the required providers.
#
# - The backend "s3" configuration tells Terraform to store its state file in an S3 bucket.
#   (Note: In a full configuration, you'll provide details such as bucket name, key, region, etc.)
#
# - The required_providers block specifies that the AWS provider will be used, sourced from
#   HashiCorp's registry.
####################################################################################################
terraform {
  backend "s3" {}  # S3 backend for storing Terraform state (further configuration details required)
  
  required_providers {
    aws = {
      source = "hashicorp/aws"  # Use the official AWS provider from HashiCorp's registry
    }
  }
}

####################################################################################################
# AWS Provider Configuration
#
# This block configures the AWS provider to target a specific AWS region.
# All AWS resources created by Terraform will be deployed to the specified region.
####################################################################################################
provider "aws" {
  region = "us-east-1"  # Set the AWS region (e.g., US East 1) for resource deployment
}
