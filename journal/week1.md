# Terraform Beginner Bootcamp 2023 - Week 1



## Root Module Structure

Our root module structure is as follows:

```
PROJECT ROOT
|
├── README.md             # Required for root modules
├── main.tf               # everything else
├── variables.tf          # stores the structure of input variables
├── terraform.tfvars      # the data of variables we want to load into our terraform project
├── providers.tf          # defines required providers and their configuration
└── outputs.tf            # store our outputs
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


