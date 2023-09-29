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

## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform we can set two kinds of variables:
- environmental variables - those you would set in your bash terminal eg. AWS credentials
- terraform variables  - those that you would normallly set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.


### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_id="my_user_id"`

### var-file flag

- TODO: document this flag

### terraform.tfvars

This is the default file to load in terraform variables in blunk.

### auto.tfvars

- TODO: document this functionallity for terraform cloud

### Order of terraform variables

- TODO: document which terraform variables takes precedence. 








