terraform { 
  # cloud {
  #   organization = "code-culturalist"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.18.1"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  # Configuration options
}