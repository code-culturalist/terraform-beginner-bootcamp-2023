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
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}
# module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version = var.content_version
# }

resource "terratowns_home" "home" {
  name = "Terraform TechGroove"
  description = <<DESCRIPTION
Dive into the world of infrastructure as code with the pulsating beats of electronic music. 
The "Terraform TechGroove" playlist is carefully curated to enhance your coding experience, 
whether you're building, provisioning, or managing cloud resources.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  #mock
  domain_name = "3fdq3gz.cloudfront.net"
  town = "melomaniac-mansion"
  content_version = 1
}