/*
SSH Key Pair Generation
- Generates a secure RSA key pair for EC2 instance access
- The private key is saved locally with 0400 permissions
*/
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/*
AWS Key Pair
- Uploads the public key to AWS
- Used for SSH access to EC2 instances
*/
resource "aws_key_pair" "generated_key" {
  key_name   = "matthew-dev-key"
  public_key = tls_private_key.ssh.public_key_openssh

  tags = {
    Name        = "matthew-dev-key"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
  }
}

/*
Local File for Private Key
- Saves the private key to a local file
- Uses strict file permissions (0400)
- Important: This file should be kept secure and never committed to version control
*/
resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/matthew-dev-key.pem"
  file_permission = "0400"

  lifecycle {
    create_before_destroy = true
  }
}

/*
EC2 Instance
- Launches an Ubuntu instance in the first public subnet
- Uses the latest Ubuntu 20.04 LTS AMI
- Associates the security group and key pair
- Auto-assigns a public IP address
*/
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  # Root volume configuration
  root_block_device {
    volume_size = 10 # GB
    volume_type = "gp3"
    encrypted   = true
  }

  # User data script to install and configure Nginx
  user_data = <<-EOF
              #!/bin/bash
              set -ex

              # Update package lists
              apt-get update -y

              # Install Nginx
              apt-get install -y nginx

              # Start and enable Nginx
              systemctl start nginx
              systemctl enable nginx

              # Create a simple index.html
              cat <<'HTML' > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Welcome to Nginx on AWS</title>
                  <style>
                      body {
                          width: 80%;
                          margin: 0 auto;
                          font-family: Arial, sans-serif;
                          text-align: center;
                          padding-top: 50px;
                      }
                      h1 {
                          color: #2c3e50;
                      }
                      .info {
                          margin: 20px 0;
                          padding: 15px;
                          background-color: #f8f9fa;
                          border-radius: 5px;
                      }
                  </style>
              </head>
              <body>
                  <h1>Welcome to Nginx on AWS</h1>
                  <div class="info">
                      <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
                      <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
                  </div>
                  <p>This page is served by Nginx on an EC2 instance provisioned with Terraform.</p>
              </body>
              </html>
              HTML

              # Set proper permissions
              chown -R www-data:www-data /var/www/html
              chmod -R 755 /var/www/html

              # Restart Nginx to apply changes
              systemctl restart nginx
              EOF

  tags = {
    Name        = "matthew-dev-ec2-web"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Role        = "web-server"
  }

  # Ensure the instance is replaced if any of these attributes change
  lifecycle {
    create_before_destroy = true
  }
}

/*
Ubuntu AMI Data Source
- Finds the latest Ubuntu 20.04 LTS AMI
- Uses Canonical's owner ID for official images
- Filters for HVM virtualization and SSD volume type
*/
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}