data "aws_availability_zones" "available" {
  state = "available"
}

#Main VPC
resource "aws_vpc" "levelup_vpc" {
    cidr_block            = var.LEVELUP_VPC_CIDR_BLOCK
    enable_dns_support    = "true"
    enable_dns_hostnames  = "true"
    tags = {
        Name = "${var.ENVIRONMENT}-vpc"
    }
}

#Public Subnets

#public subnet 1
resource "aws_subnet" "levelup_vpc_public_subnet_1" {
    vpc_id                          = aws_vpc.levelup_vpc.id
    cidr_block                      = var.LEVELUP_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
    availability_zone               = data.aws_availability_zones.available.names[0]
    map_customer_owned_ip_on_launch = "true"
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpcpublic-subnet-1"
    }
}

#public subnet 2
resource "aws_subnet" "levelup_vpc_public_subnet_2" {
    vpc_id                          = aws_vpc.levelup_vpc.id
    cidr_block                      = var.LEVELUP_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
    availability_zone               = data.aws_availability_zones.available.names[1]
    map_customer_owned_ip_on_launch = "true"
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpcpublic-subnet-2"
    }
}

#Private Subnets

#private subnet 1
resource "aws_subnet" "levelup_vpc_private_subnet_1" {
    vpc_id                          = aws_vpc.levelup_vpc.id
    cidr_block                      = var.LEVELUP_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
    availability_zone               = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-1"
    }
}

#private subnet 2
resource "aws_subnet" "levelup_vpc_private_subnet_2" {
    vpc_id                          = aws_vpc.levelup_vpc.id
    cidr_block                      = var.LEVELUP_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
    availability_zone               = data.aws_availability_zones.available.names[1]
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-2"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "levelup_igw" {
    vpc_id = aws_vpc.levelup_vpc.id
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
    }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "levelup_nat_eip" {
    domain      = "vpc"
    depends_on  = [aws_internet_gateway.levelup_igw]
}

# NAT Gateway for private subnets
resource "aws_nat_gateway" "levelup_nat_gw" {
    allocation_id = aws_eip.levelup_nat_eip.id
    subnet_id     = aws_subnet.levelup_vpc_public_subnet_1.id
    depends_on    = [aws_internet_gateway.levelup_igw]
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-nat-gateway"
    }
}

# Route Table for Public Architecture
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.levelup_vpc.id
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.levelup_igw.id
    }
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-public-route-table"
    }
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.levelup_vpc.id
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.levelup_nat_gw.id
    }

    tags = {
        Name = "${var.ENVIRONMENT}-levelup-private-route-table"
    }
}

# Route Table association with public subnets
resource "aws_route_table_association" "to_public_subnet_1" {
    subnet_id       = aws_subnet.levelup_vpc_public_subnet_1.id
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "to_public_subnet_2" {
    subnet_id       = aws_subnet.levelup_vpc_public_subnet_2.id
    route_table_id  = aws_route_table.public.id
}

# Route Table association with private subnets
resource "aws_route_table_association" "to_private_subnet_1" {
    subnet_id       = aws_subnet.levelup_vpc_private_subnet_1.id
    route_table_id  = aws_route_table.private.id
}

resource "aws_route_table_association" "to_private_subnet_2" {
    subnet_id       = aws_subnet.levelup_vpc_private_subnet_2.id
    route_table_id  = aws_route_table.private.id
}

provider "aws" {
  region = var.AWS_REGION
}

# Output to Custom VPC
output "my_vpc_id" {
    description = "VPC ID"
    value       = aws_vpc.levelup_vpc.id
}

output "private_subnet1_id" {
    description = "Private Subnet 1 ID"
    value       = aws_subnet.levelup_vpc_private_subnet_1.id
}

output "private_subnet2_id" {
    description = "Private Subnet 2 ID"
    value       = aws_subnet.levelup_vpc_private_subnet_2.id
}

output "public_subnet1_id" {
    description = "Public Subnet 1 ID"
    value       = aws_subnet.levelup_vpc_public_subnet_1.id
}

output "public_subnet2_id" {
    description = "Public Subnet 2 ID"
    value       = aws_subnet.levelup_vpc_public_subnet_2.id
}
