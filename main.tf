terraform { 
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "code-culturalist"

    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoints
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_musique_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.musique.public_path
  content_version = var.musique.content_version
  
}

resource "terratowns_home" "home" {
  name = "Explorations in electronic musique"
  description = <<DESCRIPTION
Dive into the world of infrastructure as code with the pulsating beats of electronic music. 
The "Terraform TechGroove" playlist is carefully curated to enhance your coding experience, 
whether you're building, provisioning, or managing cloud resources.
DESCRIPTION
  domain_name = module.home_musique_hosting.domain_name
  #domain_name = "*.cloudfront.net"
  town = "missingo"
  content_version = var.musique.content_version
}

module "home_bach_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.bach.public_path
  content_version = var.bach.content_version
  
}

resource "terratowns_home" "home_bach" {
  name = "Bach's Masterpiece Recommendation"
  description = <<DESCRIPTION
If you're looking to experience one of Johann Sebastian Bach's most celebrated works, 
you can't go wrong with the Brandenburg Concertos
DESCRIPTION
  domain_name = module.home_bach_hosting.domain_name
  #domain_name = "*.cloudfront.net"
  town = "missingo"
  content_version = var.bach.content_version
}