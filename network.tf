# Create the VPC
resource "aws_vpc" "network" {             # Creating VPC here
  cidr_block           = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/24 for demo
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false

  tags = {
    Name = "Final_challenge_VPC"
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
  vpc_id = aws_vpc.network.id           # vpc_id will be generated after we create VPC

  tags = {
    Name = "Final_challenge_IG"
  }
}

# Create a Public Subnets
resource "aws_subnet" "publicsubnets" { # Creating Public Subnets
  vpc_id            = aws_vpc.network.id
  cidr_block        = var.public_subnets # CIDR block of public subnets
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "Final_challenge_public_subnet"
  }
}

# Create a Public Subnets 2
resource "aws_subnet" "publicsubnets2" { # Creating Public Subnets
  vpc_id            = aws_vpc.network.id
  cidr_block        = var.public_subnets2 # CIDR block of public subnets
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "Final_challenge_public_subnet_2"
  }
}

# Create a Private Subnet                       # Creating Private Subnets
resource "aws_subnet" "privatesubnets" {
  vpc_id            = aws_vpc.network.id
  cidr_block        = var.private_subnets # CIDR block of private subnets
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "Final_challenge_private_subnet"
  }
}

# Create a Private Subnet 2                      # Creating Private Subnets
resource "aws_subnet" "privatesubnets2" {
  vpc_id            = aws_vpc.network.id
  cidr_block        = var.private_subnets2 # CIDR block of private subnets
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "Final_challenge_private_subnet_2"
  }
}

# Route table for Public Subnet
resource "aws_route_table" "PublicRT" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.network.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Final_challenge_public_RT"
  }
}

# Route table for Public Subnet 2
resource "aws_route_table" "PublicRT2" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.network.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Final_challenge_public_RT_2"
  }
}

# Route table for Private Subnet
resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.network.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "Final_challenge_private_RT"
  }
}

# Route table for Private Subnet
resource "aws_route_table" "PrivateRT2" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.network.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "Final_challenge_private_RT_2"
  }
}

# Route table Association with Public Subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.publicsubnets.id
  route_table_id = aws_route_table.PublicRT.id
}

# Route table Association with Public 2 Subnet
resource "aws_route_table_association" "PublicRT2association" {
  subnet_id      = aws_subnet.publicsubnets2.id
  route_table_id = aws_route_table.PublicRT2.id
}

# Route table Association with Private Subnet
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.privatesubnets.id
  route_table_id = aws_route_table.PrivateRT.id
}

# Route table Association with Private 2 Subnet
resource "aws_route_table_association" "PrivateRT2association" {
  subnet_id      = aws_subnet.privatesubnets2.id
  route_table_id = aws_route_table.PrivateRT2.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nateIP" {
  vpc = true
}

# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.publicsubnets.id

  tags = {
    Name = "Final_challenge_NAT"
  }
}

# Network ACL
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.network.id

  egress {
    protocol   = -1
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3306
    to_port    = 3306
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "main"
  }
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.network.id

  egress {
    protocol   = -1
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

