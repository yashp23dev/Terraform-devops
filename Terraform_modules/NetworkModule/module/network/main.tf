#AWS vpc resource
resource "aws_vpc" "custom_vpc" {
    cidr_block            = var.cidr_vpc
    enable_dns_support    = true
    enable_dns_hostnames  = true

    tags = {
      Environment         = var.environment_tag
    }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
    vpc_id = aws_vpc.custom_vpc.id

    tags = {
      Environment         = var.environment_tag
    }
}

#Aws Subnet for VPC
resource "aws_subnet" "subnet_public" {
    vpc_id                  = aws_vpc.custom_vpc.id
    cidr_block              = var.cidr_subnet
    map_public_ip_on_launch = "true"
    availability_zone       = var.availability_zone

    tags = {
      Environment           = var.environment_tag
    }
}

#AWS Route Table
resource "aws_route_table" "custom_route_table" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.custom_igw.id
    }

    tags = {
      Environment           = var.environment_tag
    }
}

#AWS Route Table Association
resource "aws_route_table_association" "custom_route_table_association" {
    subnet_id      = aws_subnet.subnet_public.id
    route_table_id = aws_route_table.custom_route_table.id
}

#AWS Security Group
resource "aws_security_group" "custom_sg" {
    name        = "custom_sg"
    description = "Custom Security Group"
    vpc_id      = aws_vpc.custom_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Environment           = var.environment_tag
    }
}
