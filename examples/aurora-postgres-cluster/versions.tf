terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }
  }
  required_version = ">= 1.3.0"

  #backend "s3" {}
}