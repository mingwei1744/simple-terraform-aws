/*
Terraform output values
Displaying information about the infrastructure deployed.
*/
output "ec2_public_ip" {
  value       = aws_instance.demoEC2.public_ip
  description = "Public IP of EC2 instance"
}

output "ec2_public_dns" {
  value       = aws_instance.demoEC2.public_dns
  description = "Public DNS of EC2 instance"
}

output "ec2_keyname" {
  value       = aws_instance.demoEC2.key_name
  description = "Keypair name of EC2 instance"
}

output "ec2_private_ip" {
  value       = aws_instance.demoEC2.private_ip
  description = "Private IP of EC2 instance"
}

