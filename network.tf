/*
VPC (Virtual Private Cloud)
- The main networking container for our AWS resources
- CIDR block defined in variables.tf (default: 10.0.0.0/16)
- DNS support and hostnames enabled for easier service discovery
*/
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "matthew-dev-vpc"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
  }
}

/*
Internet Gateway (IGW)
- Provides internet access to resources in public subnets
- Attached to the VPC
*/
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "matthew-dev-igw"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
  }
}

/*
Elastic IP for NAT Gateway
- Required for NAT Gateway to have a static public IP
- Will be associated with the NAT Gateway
*/
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "matthew-dev-eip-nat"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
  }
}

/*
NAT Gateway
- Allows resources in private subnets to access the internet
- Placed in the first public subnet
- Requires an Elastic IP
*/
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # Place NAT in first public subnet

  tags = {
    Name        = "matthew-dev-ngw"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
  }

  # Ensure IGW is created before NAT Gateway
  depends_on = [aws_internet_gateway.main]
}

/*
Public Subnets
- Have direct access to the internet via IGW
- Typically host public-facing resources like load balancers
- Each in a different AZ for high availability
*/
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = "${var.aws_region}${count.index % 2 == 0 ? "a" : "b"}"
  map_public_ip_on_launch = true # Auto-assign public IP to instances

  tags = {
    Name        = "matthew-dev-sn-public-${count.index + 1}"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Network     = "public"
  }
}

/*
Private Subnets
- No direct internet access
- Can access internet through NAT Gateway
- Typically host application servers, databases
*/
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = "${var.aws_region}${count.index % 2 == 0 ? "a" : "b"}"
  map_public_ip_on_launch = false # No public IPs for private subnets

  tags = {
    Name        = "matthew-dev-sn-private-${count.index + 1}"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Network     = "private"
  }
}

/*
Public Route Table
- Associated with public subnets
- Routes all traffic (0.0.0.0/0) to Internet Gateway
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "matthew-dev-rt-public"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Network     = "public"
  }
}

/*
Private Route Table
- Associated with private subnets
- Routes all traffic (0.0.0.0/0) to NAT Gateway
*/
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "matthew-dev-rt-private"
    Environment = "dev"
    Project     = "matthew"
    ManagedBy   = "terraform"
    Network     = "private"
  }
}

/*
Public Route Table Association
- Associates each public subnet with the public route table
*/
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

/*
Private Route Table Association
- Associates each private subnet with the private route table
*/
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}