/*
Instance Public IP
- The public IP address of the EC2 instance
- Used to access the instance via SSH or HTTP
*/
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
  sensitive   = false

  depends_on = [aws_instance.web]
}

/*
Instance Public DNS
- The public DNS name of the EC2 instance
- Can be used to access the web server
*/
output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = "http://${aws_instance.web.public_dns}"
  sensitive   = false

  depends_on = [aws_instance.web]
}

/*
Private Key Path
- Local filesystem path where the private key is saved
- Used for SSH access to the instance
- Marked as sensitive to avoid accidental exposure
*/
output "private_key_path" {
  description = "Filesystem path to the generated private key"
  value       = local_file.private_key.filename
  sensitive   = true
}

/*
VPC ID
- The ID of the created VPC
- Useful for reference in other configurations
*/
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

/*
Public Subnet IDs
- List of public subnet IDs
- Useful for launching other resources in public subnets
*/
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

/*
Private Subnet IDs
- List of private subnet IDs
- Useful for launching resources in private subnets
*/
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

/*
Security Group ID
- The ID of the web server security group
- Useful for adding rules or attaching to other resources
*/
output "web_security_group_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.web.id
}

/*
SSH Connection Command
- Pre-formatted SSH command to connect to the instance
- Includes the correct key and username for the AMI
*/
output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${local_file.private_key.filename} ubuntu@${aws_instance.web.public_dns}"
  sensitive   = true  # Contains sensitive key path
}

/*
Web Server URL
- Direct URL to access the web server
- Assumes the server is running on port 80
*/
output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web.public_dns}"
}