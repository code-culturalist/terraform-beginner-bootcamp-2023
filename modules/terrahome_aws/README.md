## Terrahome AWS

```
module "home_musique" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.musique_public_path
  content_version = var.content_version
}
```

The public directory expects the following:
- index.html
- error.html
- assets (directory)

All top level files in assets will be copied, but not any subdirectories.