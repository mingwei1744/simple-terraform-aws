# Simple Terraform - AWS
A simple demo on the use of Terraform for deployments to AWS cloud

## Prerequisites
* AWS
* Terraform
* IDE that supports Terraform

## Setup AWS
a) Visit [AWS](https://aws.amazon.com/) and create an account. <br />

b) Create an [access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html?icmpid=docs_iam_console) under IAM services. This credentials will be used for as providers on Terraform.  <br />

c) Install [AWS CLI](https://aws.amazon.com/cli/) or any AWS related tool kit <br />
> Check if awscli has been successfully installed and configure your AWS credentials to be used for deployment. <br />
```
awscli 
```
d) Configure your AWS profile with the access key created in Step b. <br />
```
aws configure
```
e) Alternatively, you can edit the config and credentials files. <br />
> credentials
```
[profile-name]
aws_access_key_id = <key_id>
aws_secret_access_key = <access_key>
aws_session_token = <session_token>
```

> config
```
[profile-name]
region = <aws_region>
```

## Setup Terraform
a) Download [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and add binary to PATH <br />
> Check if Terraform has been successfully installed <br />
```
terraform --version
```

## Setup IDE
a) Recommended to have an IDE supporting Terraform (hcl) <br />
    > [Visual Studio Code](https://code.visualstudio.com/) <br />
    > [Atom](https://atom.io/) <br />
    > [PyCharm](https://www.jetbrains.com/pycharm/) <br />
    
## Deployment
a) Initialize a working directory containing Terraform configuration files.
    > From the main working directory /demo-ec2 run terraform init
```
terraform init
```

b) Preview execution plan
    > From the main working directory /demo-ec2 run terraform plan
```
terraform plan
```
c) Start deployment
> From the main working directory /demo-ec2 run terraform apply. By default, the default aws profile will be used.
```
terraform apply
```

> If you have configured aws profile
```
terraform apply -var="aws_profile=<profile_name>"
```
