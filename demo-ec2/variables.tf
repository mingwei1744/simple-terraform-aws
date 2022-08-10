/*
Terraform input variables
Used for customization of Terraform modules through user input
*/
# AWS Profile name for providers configuration
variable "aws_profile" {
  description = "AWS profile for programmatic access"
  type        = string
  default     = "default"
}

# Objects naming convention
variable "naming" {
  description = "Naming convention of objects"
  type        = string
  default     = "demo"
}

# Number of public subnets
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

# Number of private subnets
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
}

# Number of Availability Zone
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}
