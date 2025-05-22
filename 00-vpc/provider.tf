terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

    backend "s3" {
    bucket         = "expense-eks-remote-state"
    key            = "eks-vpc-state-file"
    region         = "us-east-1"
    dynamodb_table = "expense-eks-dev-table"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

}

