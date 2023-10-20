terraform { 
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  # cloud {
  #   organization = "code-culturalist"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoints
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Explorations in electronic musique"
  description = <<DESCRIPTION
Dive into the world of infrastructure as code with the pulsating beats of electronic music. 
The "Terraform TechGroove" playlist is carefully curated to enhance your coding experience, 
whether you're building, provisioning, or managing cloud resources.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  #domain_name = "*.cloudfront.net"
  town = "missingo"
  content_version = 1
}