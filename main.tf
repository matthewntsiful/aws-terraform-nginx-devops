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

  # User data script to install and configure Nginx with modern web page
  user_data = <<-EOF
              #!/bin/bash
              set -ex

              # Update package lists
              apt-get update -y

              # Install Nginx and system utilities
              apt-get install -y nginx curl jq

              # Start and enable Nginx
              systemctl start nginx
              systemctl enable nginx

              # Get instance metadata
              INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
              AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
              REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
              INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

              # Create modern index.html
              cat <<'HTML' > /var/www/html/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>AWS DevOps Infrastructure | Terraform + Nginx</title>
                  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                  <style>
                      * {
                          margin: 0;
                          padding: 0;
                          box-sizing: border-box;
                      }
                      
                      body {
                          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          min-height: 100vh;
                          color: #333;
                      }
                      
                      .container {
                          max-width: 1200px;
                          margin: 0 auto;
                          padding: 20px;
                      }
                      
                      .header {
                          text-align: center;
                          margin-bottom: 40px;
                          animation: fadeInDown 1s ease-out;
                      }
                      
                      .header h1 {
                          color: white;
                          font-size: 3rem;
                          margin-bottom: 10px;
                          text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                      }
                      
                      .header p {
                          color: rgba(255,255,255,0.9);
                          font-size: 1.2rem;
                      }
                      
                      .status-badge {
                          display: inline-block;
                          background: #28a745;
                          color: white;
                          padding: 8px 16px;
                          border-radius: 20px;
                          font-weight: bold;
                          margin: 10px 0;
                          animation: pulse 2s infinite;
                      }
                      
                      .cards-grid {
                          display: grid;
                          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                          gap: 20px;
                          margin-bottom: 40px;
                      }
                      
                      .card {
                          background: white;
                          border-radius: 15px;
                          padding: 25px;
                          box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                          transition: transform 0.3s ease, box-shadow 0.3s ease;
                          animation: fadeInUp 1s ease-out;
                      }
                      
                      .card:hover {
                          transform: translateY(-5px);
                          box-shadow: 0 20px 40px rgba(0,0,0,0.15);
                      }
                      
                      .card-header {
                          display: flex;
                          align-items: center;
                          margin-bottom: 20px;
                      }
                      
                      .card-icon {
                          font-size: 2rem;
                          margin-right: 15px;
                          color: #667eea;
                      }
                      
                      .card-title {
                          font-size: 1.5rem;
                          font-weight: bold;
                          color: #333;
                      }
                      
                      .info-item {
                          display: flex;
                          justify-content: space-between;
                          align-items: center;
                          padding: 10px 0;
                          border-bottom: 1px solid #eee;
                      }
                      
                      .info-item:last-child {
                          border-bottom: none;
                      }
                      
                      .info-label {
                          font-weight: 600;
                          color: #666;
                      }
                      
                      .info-value {
                          font-family: 'Courier New', monospace;
                          background: #f8f9fa;
                          padding: 4px 8px;
                          border-radius: 4px;
                          font-size: 0.9rem;
                      }
                      
                      .tech-stack {
                          display: flex;
                          flex-wrap: wrap;
                          gap: 10px;
                          margin-top: 15px;
                      }
                      
                      .tech-badge {
                          background: linear-gradient(45deg, #667eea, #764ba2);
                          color: white;
                          padding: 5px 12px;
                          border-radius: 15px;
                          font-size: 0.8rem;
                          font-weight: bold;
                      }
                      
                      .footer {
                          text-align: center;
                          color: rgba(255,255,255,0.8);
                          margin-top: 40px;
                      }
                      
                      .footer a {
                          color: white;
                          text-decoration: none;
                          font-weight: bold;
                      }
                      
                      @keyframes fadeInDown {
                          from {
                              opacity: 0;
                              transform: translateY(-30px);
                          }
                          to {
                              opacity: 1;
                              transform: translateY(0);
                          }
                      }
                      
                      @keyframes fadeInUp {
                          from {
                              opacity: 0;
                              transform: translateY(30px);
                          }
                          to {
                              opacity: 1;
                              transform: translateY(0);
                          }
                      }
                      
                      @keyframes pulse {
                          0% { transform: scale(1); }
                          50% { transform: scale(1.05); }
                          100% { transform: scale(1); }
                      }
                      
                      @media (max-width: 768px) {
                          .header h1 {
                              font-size: 2rem;
                          }
                          .cards-grid {
                              grid-template-columns: 1fr;
                          }
                      }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <div class="header">
                          <h1><i class="fas fa-cloud"></i> AWS DevOps Infrastructure</h1>
                          <p>Terraform-Provisioned Nginx Server</p>
                          <div class="status-badge">
                              <i class="fas fa-check-circle"></i> OPERATIONAL
                          </div>
                      </div>
                      
                      <div class="cards-grid">
                          <div class="card">
                              <div class="card-header">
                                  <i class="fas fa-server card-icon"></i>
                                  <div class="card-title">Instance Details</div>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Instance ID:</span>
                                  <span class="info-value">INSTANCE_ID_PLACEHOLDER</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Instance Type:</span>
                                  <span class="info-value">INSTANCE_TYPE_PLACEHOLDER</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Region:</span>
                                  <span class="info-value">REGION_PLACEHOLDER</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Availability Zone:</span>
                                  <span class="info-value">AZ_PLACEHOLDER</span>
                              </div>
                          </div>
                          
                          <div class="card">
                              <div class="card-header">
                                  <i class="fas fa-network-wired card-icon"></i>
                                  <div class="card-title">Network Configuration</div>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Public IP:</span>
                                  <span class="info-value">PUBLIC_IP_PLACEHOLDER</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Private IP:</span>
                                  <span class="info-value">PRIVATE_IP_PLACEHOLDER</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">VPC:</span>
                                  <span class="info-value">Custom VPC (10.0.0.0/16)</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Subnet:</span>
                                  <span class="info-value">Public Subnet</span>
                              </div>
                          </div>
                          
                          <div class="card">
                              <div class="card-header">
                                  <i class="fas fa-cogs card-icon"></i>
                                  <div class="card-title">Technology Stack</div>
                              </div>
                              <div class="tech-stack">
                                  <span class="tech-badge"><i class="fab fa-aws"></i> AWS EC2</span>
                                  <span class="tech-badge"><i class="fas fa-cube"></i> Terraform</span>
                                  <span class="tech-badge"><i class="fas fa-server"></i> Nginx</span>
                                  <span class="tech-badge"><i class="fab fa-ubuntu"></i> Ubuntu 20.04</span>
                                  <span class="tech-badge"><i class="fab fa-github"></i> GitHub Actions</span>
                                  <span class="tech-badge"><i class="fas fa-shield-alt"></i> Security Groups</span>
                                  <span class="tech-badge"><i class="fas fa-cloud"></i> VPC</span>
                                  <span class="tech-badge"><i class="fas fa-database"></i> S3 + DynamoDB</span>
                              </div>
                          </div>
                          
                          <div class="card">
                              <div class="card-header">
                                  <i class="fas fa-chart-line card-icon"></i>
                                  <div class="card-title">Infrastructure Status</div>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Deployment:</span>
                                  <span class="info-value" style="color: #28a745;">✅ Successful</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Web Server:</span>
                                  <span class="info-value" style="color: #28a745;">✅ Running</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">SSL/TLS:</span>
                                  <span class="info-value" style="color: #ffc107;">⚠️ Not Configured</span>
                              </div>
                              <div class="info-item">
                                  <span class="info-label">Monitoring:</span>
                                  <span class="info-value" style="color: #17a2b8;">ℹ️ CloudWatch</span>
                              </div>
                          </div>
                      </div>
                      
                      <div class="footer">
                          <p>🚀 Deployed with <strong>Infrastructure as Code</strong> | 
                          Built by <a href="mailto:matthew.ntsiful@gmail.com">Matthew Ntsiful</a></p>
                          <p style="margin-top: 10px; font-size: 0.9rem;">
                              <i class="fas fa-clock"></i> Last Updated: <span id="timestamp"></span>
                          </p>
                      </div>
                  </div>
                  
                  <script>
                      // Set current timestamp
                      document.getElementById('timestamp').textContent = new Date().toLocaleString();
                      
                      // Add some interactivity
                      document.querySelectorAll('.card').forEach(card => {
                          card.addEventListener('click', function() {
                              this.style.transform = 'scale(0.98)';
                              setTimeout(() => {
                                  this.style.transform = '';
                              }, 150);
                          });
                      });
                  </script>
              </body>
              </html>
              HTML

              # Replace placeholders with actual values
              sed -i "s/INSTANCE_ID_PLACEHOLDER/$INSTANCE_ID/g" /var/www/html/index.html
              sed -i "s/INSTANCE_TYPE_PLACEHOLDER/$INSTANCE_TYPE/g" /var/www/html/index.html
              sed -i "s/REGION_PLACEHOLDER/$REGION/g" /var/www/html/index.html
              sed -i "s/AZ_PLACEHOLDER/$AZ/g" /var/www/html/index.html
              sed -i "s/PUBLIC_IP_PLACEHOLDER/$PUBLIC_IP/g" /var/www/html/index.html
              sed -i "s/PRIVATE_IP_PLACEHOLDER/$PRIVATE_IP/g" /var/www/html/index.html

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
