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
The default location of the shared AWS config and credentials files are resided in .aws folder placed in the "home" directory on your computer.
![default config location](https://github.com/mingwei1744/simple-terraform-aws/blob/main/config-location.PNG)
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
> From the main working directory /demo-ec2 run terraform plan. By default, the default aws profile will be used.
```
terraform plan
```

> If you have configured aws profile
```
terraform plan -var="aws_profile=<profile_name>"
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

## Connecting to the EC2 instance
a) Upon successful deployment, a keypair "demoKey.pem" will be generated in the /demo-ec2 directory.
> SSH to the EC2 instance using the keypair. Public DNS of the EC2 instance can be found in the outputs or AWS web interface.
```
ssh -i "demoKey.pem" ubuntu@<public_dns>
```

## Removing deployment
a) To remove all objects deployed
> From the main working directory /demo-ec2 run terraform destroy
```
terraform destroy
```

> If you have configured aws profile
```
terraform destroy -var="aws_profile=<profile_name>"
```
