/*
Main configurations of Terraform deployment
This can be converted into a module package in a deployment with multiple objects
*/

# Local variables
locals {
  region     = "ap-southeast-1" // Singapore
  ubuntu_ami = "ami-02ee763250491e04a" // Ubuntu 22.04 AMI
}

# Get the available zone based on the region set
data "aws_availability_zones" "available" {}

#===========================================================================================
# CREATE VPC
# Resource: aws_vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# When creating a VPC, default Route Table, NACL, Security Group will be created
#===========================================================================================
resource "aws_vpc" "demoVPC" {
  cidr_block                       = "10.0.0.0/16" // IPv4 CIDR block
  assign_generated_ipv6_cidr_block = false         // IPv6 CIDR block
  instance_tenancy                 = "default"     // Tenancy

  enable_dns_hostnames = true // DNS option (Default: False)
  enable_dns_support   = true // DNS option (Default: True)

  tags = {
    Name = "demoVPC"
  }
}


#===========================================================================================
# CREATE PUBLIC SUBNETS
# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#===========================================================================================
resource "aws_subnet" "public-sn" {
  count             = length(var.public_subnets) // Number of public subnets = len(var.public_subnets)
  vpc_id            = aws_vpc.demoVPC.id // Reference to resource syntax: <resource_type>.<resource_name>.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index] // Retrieve data of aws_availability_zones

  tags = {
    Name = format("%s-public-%s", var.naming, element(var.azs, count.index)) // Name formatting, similar to string.format
  }
}


#===========================================================================================
# CREATE PRIVATE SUBNETS
#===========================================================================================
resource "aws_subnet" "private-sn" {
  count             = length(var.private_subnets) // Number of private subnets = len(var.private_subnets)
  vpc_id            = aws_vpc.demoVPC.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-private-%s", var.naming, element(var.azs, count.index))
  }
}


#===========================================================================================
# CREATE INTERNET GATEWAY AND ATTACH IT TO VPC
#===========================================================================================
resource "aws_internet_gateway" "demoVPC-igw" {
  vpc_id = aws_vpc.demoVPC.id

  tags = {
    Name = "demoVPC-igw"
  }

}


#===========================================================================================
# CREATE ROUTE TABLE FOR PUBLIC SUBNETS
# n Public Subnets = 1 Route Table
# n : 1
#===========================================================================================
resource "aws_route_table" "publicRT" {
  count  = length(var.public_subnets) > 0 ? 1 : 0 # Map all public subnet into 1 RT
  vpc_id = aws_vpc.demoVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demoVPC-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.demoVPC-igw.id
  }

  tags = {
    Name = "demoVPC-publicRT"
  }
}

# Associate public subnet with public Route Table
resource "aws_route_table_association" "publicRT-sn-association" {
  count          = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0 // If len(public_subnets) > 0: Create len(public_subnets) associations
  subnet_id      = element(aws_subnet.public-sn[*].id, count.index)                // Get each of the public_subnets element
  route_table_id = aws_route_table.publicRT[0].id                                  // Get publicRT id
}


#===========================================================================================
# CREATE ROUTE TABLES FOR PRIVATE SUBNETS
# n Private Subnets = n Route Table
# 1 : 1
#===========================================================================================
resource "aws_route_table" "privateRT" {
  count  = length(var.private_subnets) // len(private_subnets) = number of privateRT
  vpc_id = aws_vpc.demoVPC.id

  tags = {
    Name = "demoVPC-privateRT"
  }
}

# Associate private subnet with private Route Table
resource "aws_route_table_association" "privateRT-sn-association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private-sn[*].id, count.index)     // Get the subnet_id of each subnet
  route_table_id = element(aws_route_table.privateRT[*].id, count.index) // Get the privateRT_id of each privateRT
}


#===========================================================================================
# *AMEND? DEFAULT NETWORK ACL
# Default Inbound / Outbound: Allow all traffic
# Since all traffic allowed, associate with public subnets
#===========================================================================================
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.demoVPC.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = format("%s-default-nacl", var.naming)
  }
}


#===========================================================================================
# CREATE NETWORK ACL FOR PUBLIC PRIVATE SUBNETS
# 
#===========================================================================================
resource "aws_network_acl" "private-acl" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.demoVPC.id
  subnet_ids = aws_subnet.private-sn[*].id

  ingress {
    protocol   = "tcp"
    rule_no    = 22
    action     = "allow"
    cidr_block = "0.0.0.0/0" // This allows SSH connection from all sources. Recommended to change to your public IP
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = format("%s-private-nacl", var.naming)
  }

}


#===========================================================================================
# *AMEND? DEFAULT SECURITY GROUP
# Default Inbound / Outbound: Allow all traffic
#===========================================================================================
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.demoVPC.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# End of VPC configurations


# Start of EC2 configurations
#*******************************************************************************************
# CREATE KEY PAIR
# Used for remote connection to EC2 instances
#*******************************************************************************************
resource "tls_private_key" "demoKey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "demoKey"
  public_key = tls_private_key.demoKey.public_key_openssh

}

# Write private key to local file (not recommended). This will be saved in the statefile.
# If using this method, ensure the terraform statefile is encrypted
# For demo purposes
resource "local_file" "ssh_key" {
  filename = "./${aws_key_pair.generated_key.key_name}.pem"
  content  = tls_private_key.demoKey.private_key_pem
}


#*******************************************************************************************
# CREATE SECURITY GROUP FOR EC2 INSTANCE
#*******************************************************************************************
# Create Security Group to allow SSH (port 22)
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH access to EC2 instance"
  vpc_id      = aws_vpc.demoVPC.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // This allows SSH connection from all sources. Recommended to change to your public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}


#*******************************************************************************************
# CREATE EC2 INSTANCE
#*******************************************************************************************
# Using "data" to retrieve latest ami 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "demoEC2" {
  #ami           = local.ubuntu_ami
  ami           = data.aws_ami.ubuntu.id              // Amazon Machine Image
  instance_type = "t2.micro"                          // Instance type
  key_name      = aws_key_pair.generated_key.key_name // Key pair (login)

  subnet_id                   = element(aws_subnet.public-sn[*].id, 0) // Subnet
  associate_public_ip_address = true                                   // Auto-assign public IP
  vpc_security_group_ids      = [aws_security_group.allow-ssh.id]      // Security group

  // Configure storage
  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = "${file("../scripts/demo.sh")}" // User data

  tags = {
    Name = "demoEC2"
  }
}
# End of EC2 configurations