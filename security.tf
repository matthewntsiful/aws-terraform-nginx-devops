/*
Web Server Security Group
- Controls inbound/outbound traffic for web servers
- Attached to EC2 instances that need to serve web traffic
- Follows principle of least privilege
*/
resource "aws_security_group" "web" {
  name        = "matthew-dev-sg-web"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  /*
  Inbound HTTP (Port 80)
  - Allows HTTP traffic from anywhere
  - Required for public web access
  */
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*
  Inbound HTTPS (Port 443)
  - Allows HTTPS traffic from anywhere
  - Required for secure web access
  */
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*
  Inbound SSH (Port 22)
  - Restrict this to your IP in production
  - Currently open to the world for demonstration
  */
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production!
  }

  /*
  Outbound Traffic
  - Allows all outbound traffic
  - Consider restricting this to specific destinations in production
  */
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "matthew-dev-sg-web"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Role        = "web-server"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*
Database Security Group
- Controls access to database instances
- Only allows traffic from web servers
*/
resource "aws_security_group" "database" {
  name        = "matthew-dev-sg-db"
  description = "Security group for database access"
  vpc_id      = aws_vpc.main.id

  /*
  Inbound PostgreSQL (Port 5432)
  - Only allows traffic from web servers
  - Adjust the port if using a different database
  */
  ingress {
    description     = "PostgreSQL"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  /*
  Outbound Traffic
  - Allows database to respond to requests
  */
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "matthew-dev-sg-db"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Role        = "database"
  }
}