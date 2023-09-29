terraform { 
  # cloud {
  #   organization = "code-culturalist"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.18.1"
    }
  }
}

# provider "random" {
#   # Configuration options
# }

provider "aws" {
  # Configuration options
}