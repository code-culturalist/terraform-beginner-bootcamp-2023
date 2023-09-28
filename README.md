# Terraform Beginner Bootcamp 2023

## Semantic Versioning


This project  is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)    :mage:


The general format:


**MAJOR.MINOR.PATCH**,  eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.



## Install the Terraform CLI

The Terraform CLI installation instructions have changed dur to gpg keyring changes. So we needed to refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider cheking your Linux Distribution and change accordingly to your distribution needs.

[How to check OS Version in Linux](
https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version:

```
$ cat /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```


### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues we noticed that bash scripts were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli.sh](./bin/install_terraform_cli.sh)

- This will keep the GitPod task file ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CLI.


#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what program that wil interpret the script.

ChatGPT recommend this format for bash: `#!/usr/bin/env bash`

- for portability for different  OS distributions 
- will search the user's PATH for the bash executable.


#!/bin/bash
#!/usr/bin/env bash



https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli.sh`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

ed. `source ./bin/install_terraform_cli.sh`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linus persmisson for the fix to be executable at the user mode.

```sh
chmod y+x ./bin/install_terraform_cli.sh
```

We can also alternatively:

```sh
chmod 0744 ./bin/install_terraform_cli.sh
```


https://en.wikipedia.org/wiki/Chmod


### GitHub Lifecycle (Before, Init, Command)

We need to be careful when using he Init because it will not rerun if we restart an existing workspace (gitpod) 

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working with Env Vars

#### env command

We can list out all Environment Variables (Env Vars) using the `env` command.

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and unsetting Env vars

In the terminal we can set using `export HELLO="world"`

We can set an env var temporaly when just running a command


```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Vars


We can print an env var using echo eg. `echo $HELLO`


#### Scoping of Env VARs

When you open up new bash terminal in VSCode it will not be aware of env vars that you have set in another window. 

If you want to Env Vars to persist across all future terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`


#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.


```
gp env HELLO='world'
```

All future workspace launched will set the env vars for all bash terminal opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.


### AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can chedk if our AWS credentials is configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity 
```


If it is successful you should see a JSON payload return that looks like this:

```json
{
    "UserId": "AIJQHQH7QL7639WO99HJ1"
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from IAM user in order to the user AWS CLI.


## Terraform Basics

### Terraform Registry

Terraform source their providers and modules from the terraform registry which  located at [registry.terraform.io](https://registry.terraform.io/)


- **Providers** is an interface to APIs that will allow to create resources in terraform.
- **Modules** are a way to refactor or make large amount of terraform code modular, portable and shareable.

### Terraform Console

We can see a list of all the terraform command by simply typing `terraform`

#### Terraform Init

`terraform init`
At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan

`terraform plan`
This will generate out a changeset, about the state of our infrastructure and what will be changed. 

We can output this changeset ie. "plan" to be passes to an apply, but often you can just ignore outputting.


#### Terraform Apply

`terraform apply`
This will run a plan and pass the changeset to be execute by terraform. Apply should prompt us yes or no. 

If we want to automatically approve an apply we can provide the auto approve flag. eg. `terraform apply --auto-approve` 

#### Terraform Destroy

`terraform destroy`
This will destroy resources.

You can also use the auto approve flag to skip the approve prompt, eg. `terraform destroy --auto-approve`


#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project. 

The terraform lock file **should be committed** to your Version Control System (VCS) eg. GitHub.

#### Terraform State Files
 
`.terraform.tfstate` contain information about the current state of your infrastructure.

This file should **not be committed** to your version control system. 

This file can contain sensitive data.

If you loose this file, you loose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.


## Issues with Terraform Cloud Logging and Gitpod Workspace

When attempting to run `terraform login` it will launch in bash a WYSIWYG view to generate a token. However it does not work expected in Gitpod VSCode in the browser.

The workaround is manually generate a token in Terraform Cloud:

```
https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login

```

Then create open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file) .

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "<YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}

```

We have automated this workaround with the following BASH script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)