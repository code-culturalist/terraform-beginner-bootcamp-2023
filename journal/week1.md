# Terraform Beginner Bootcamp 2023 - Week 1


## Fixing Tags

[How to delete local and remote tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)


Locally delete a tag
```sh
git tag -d <tag_name>
```

Remotelly delete a tag
```sh
git push --delete origin tagname
```
(we need to do both)

Checkout the commit that you want to retag. Grab the SHA from your GitHub history.

```sh
git checkout <SHA>
git tag <M.M.P>
git push --tags
git checkout main
```

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


## Dealing With Configuration Drift

## What happens if we lose our state file?

If you lose your state file, you most likely have to tear down all you cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check the terraform provider documentation for which resources support import.


### Fix Missing Resource with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket import](https://developer.hashicorp.com/terraform/cli/import)

### Fix Manual Configuration

If someone goes and delete or modifies our cloud resources manually through ClickOps, if we run terraform plan again, is going to attempt to put our infrastructure back into the expected state fixing Configuration Drift 

## Fix using Terraform Refresh

```
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing module, but you can name it whatever you like. 

### Passing Input Variables

We can pass input variable to our module.

The module has to declare this terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name

}
```

### Module Sources

Using the source we can import the module from various places eg. 
- Locally
- GitHub
- Terraform Registry


[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write terraform

LLMs such as ChatGPT may not be trained on the latest documentation or informamtion about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with files in Terraform

### Fileexists function
https://developer.hashicorp.com/terraform/language/functions/fileexists

This is a built-in terraform function to check the existance of a file.
(here also the `can` funtion it's been used)

```tf
    condition     = can(fileexists(var.index_html_filepath))
```

### Filemd5 function
https://developer.hashicorp.com/terraform/language/functions/filemd5

We used this funtion to create an etag, so that when a file changes, the terraform resource that uses that file know that there has been a change and the change applies.

### Path Variable 

In Terrraform there is a special variable called `path` that allows us to reference local paths:
- path.module - is the filesystem path of the module where the expression is placed
- path.root - is the filesystem path of the root module of the configuration.
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)




```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"

  etag = filemd5(var.index_html_filepath)
}
```

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a variable.  

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows use to source data from cloud resources.
This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the `jsonencode` to create the json policy inline in the HCL.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}

```
[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


### Changing the lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

[The terraform_data managed Resource](https://developer.hashicorp.com/terraform/language/resources/terraform-data)


## Provisioners

Provisioners allow you to execute commands on compute instances eg. AWS CLI command.
They are not recommended for use by Hashicorp because Configuration Management toosl such as Ansible are better fit, but the functionality exists.

[Provisiones (are the last resort)](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec


```
### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}

```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec


## for_each expressions

[for_each meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

for_each allows us to enumerate over complex data types

```tf
# my_buckets.tf
module "bucket" {
  for_each = toset(["assets", "media"])
  source   = "./publish_bucket"
  name     = "${each.key}_bucket"
}
```

This is mostly useful when ou are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

