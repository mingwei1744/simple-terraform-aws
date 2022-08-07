# Simple Terraform - AWS
A simple demo on the use of Terraform for deployments to AWS cloud

## Prerequisites
* AWS
* Terraform
* IDE that supports Terraform

## Setup AWS
a) Visit [AWS](https://aws.amazon.com/) and create an account. <br />

b) Create an [access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html?icmpid=docs_iam_console) under IAM services. This credentials will be used for as providers on Terraform.  <br />

c) Install AWS CLI or any AWS related tool kit <br />
    > [AWS CLI installation](https://aws.amazon.com/cli/) <br />
    > Check if awscli has been successfully installed and configure your AWS credentials to be used for deployment. <br />
```
awscli 
```
d) Configure your AWS profile with the access key created in Step b. <br />
```
aws configure
```

## Setup Terraform
Download Terraform and add binary into environment variables <br />
    > [Terraform installation](https://learn.hashicorp.com/tutorials/terraform/install-cli) <br />
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
    > From the main working directory /demo-ec2 run terraform apply
```
terraform apply
```
