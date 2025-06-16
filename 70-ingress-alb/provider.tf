terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92.0"
    }
  }

    backend "s3" {
    bucket         = "expense-infra-remote-states"
    key            = "alb-ingress-state-file"
    region         = "us-east-1"
    dynamodb_table = "expense-infra-dev-table"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

}